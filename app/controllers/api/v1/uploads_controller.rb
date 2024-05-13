module Api
  module V1
    class UploadsController < ApplicationController
      include SwagDocs::UploadsDoc
      before_action :authorize_request, except: %i[show index public_downloads_list]
      before_action :set_upload, except: %i[create index dashboard public_downloads_list]
      after_action :track_action, only: %i[download_file]
      after_action :update_infos_dataset, only: %i[create update upload_file download_file]

      def index
        public_uploads = Rails.cache.fetch([Upload.first.cache_key, __method__], expires_in: 20.minutes) do
          Upload.public_status
                .includes(:upload_attachment)
                .references(:upload_attachment)
                .order(name: :asc)
        end
        public_uploads_paginated = paginate_collection(uploads_filtered(public_uploads), params[:page], 5)
        render json: public_uploads_paginated, each_serializer: PublicUploadsSerializer,
          include: [:upload_attachment, UploadAttachmentSerializer]
      end

      def dashboard

        render json: current_user.admin_uploads, each_serializer: AdminUploadsSerializer,
                     include: [[:upload_attachment, UploadAttachmentSerializer], [:webhooks, WebhookSerializer]]
      end

      def create
        @upload = Upload.new(upload_params.merge(user_id: @current_user.id))
        @upload.save!
        render json: @upload, serializer: serializer, status: 201
      end

      def update
        @upload.update!(upload_params)
        current_user_rate = { 'user_id': @current_user.id, 'upload_id': @upload.id, 'rating': @upload.rating }.to_json
        if @upload.saved_change_to_rating?
          collect_rates = Uploads::IndRatesCollectingWorker.perform_async(current_user_rate)
          Rails.logger.info(Sidekiq::Status.get(collect_rates, :result))
        end
        render json: @upload, serializer: serializer
      end

      def upload_file
        if params[:file].blank?
          render json: { status: :not_acceptable, message: 'Please add a file' }, status: 406
        else
          file = params[:file]
          attachment = @upload.build_upload_attachment
          attachment.attach(
            io: file.tempfile,
            filename: file.original_filename,
            content_type: file.content_type
          )
          attachment.save!
          @upload.update!(version: @upload.version + 1)
          render json: attachment, serializer: UploadAttachmentSerializer
        end
      end

      def remove_file
        @upload.upload_attachment&.purge
        @upload.upload_attachment&.destroy!
      end

      def download_file
        if @upload.upload_attachment && @upload.upload_attachment.attached?
        download = @upload.upload_attachment.blob.download
        @upload.update!(downloads_count: @upload.downloads_count + 1)
        location_setup(@upload) if Rails.env.production?
        render json: { "file": Base64.encode64(download.to_s) }
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      def destroy
        @upload.destroy!
      end

      def show
        render json: @upload, serializer: serializer
      end

      def load_prediction_for_infos
        result = DiscoServices::UploadsRecommender.call(@upload.uploads_info_ids)
        @upload.uploads_infos.update_all(rating: result)
        render json: { 'predicted rating': result }
      end

      def update_infos_dataset
        fv = FolderVersion.create!(upload_id: @upload_id, user_id: @current_user.id, version: 1)
        job = UploadsInfos::UpdateDatasetJob.new.bulk_update(@current_user.id, @upload.id, fv.id)
        Rails.logger.info(Sidekiq::Status.get(job, :bulk_results))
      end

      def update_recs_by_infos
        DiscoServices::UpdateInfosRecsToVersion.(@upload.id)
      rescue StandardError
        render json: no_training_data, status: no_training_data[:status]
      end

      def public_downloads_list
        downloads = Upload.public_status
                          .downloaded
                          .eager_load(:upload_attachment)
                          .order(downloads_count: :desc)
        public_downloads_paginated = paginate_collection(uploads_filtered(downloads), params[:page], 5)
        render json: public_downloads_paginated, each_serializer: PublicDownloadsSerializer,
          include: [:upload_attachment, UploadAttachmentSerializer]
      end

      protected

      def track_action
        ahoy.track "Record #{@upload.id} Downloaded", request.path_parameters
      end

      private

      def serializer
        UploadSerializer
      end

      def upload_params
        params.require(:upload).permit(:user_id, :name, :file, :rating, :category, :topic, :date)
      end

      def set_upload
        @upload = Upload.find(params[:id])
      end

      def filter_params
        params[:filter] ? params.require[:search].permit(:user_id, :topic, :category, :date, :name) : {}
      end

      def filter
        filter_params[:search].present? ? filter_params[:search] : ''
      end

      def uploads_filtered(collection)
        FilterRecords.new(collection).call(filter)
      end
    end
  end
end
