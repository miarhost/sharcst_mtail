module Api
  module V1
    class UploadsController < ApplicationController
      before_action :authorize_request, except: %i[show index]
      before_action :set_upload, except: %i[create index dashboard]

      def index
        public_uploads = Rails.cache.fetch([Upload.first.cache_key, __method__], expires_in: 20.minutes) do
          Upload.includes(:upload_attachment)
                      .references(:upload_attachment)
                      .order(name: :asc)
        end
        render json: public_uploads, each_serializer: PublicUploadsSerializer, include: [:upload_attachment, UploadAttachmentSerializer]
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
          render json: attachment, serializer: UploadAttachmentSerializer
        end
      end

      def remove_file
        @upload.upload_attachment&.purge
        @upload.upload_attachment&.destroy!
      end

      def download_file
        if @upload.upload_attachment
        download = @upload.upload_attachment.download
        @upload.downloads_count += 1
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
        result = DiscoServices::UploadsRecommender.call(@upload.uploads_infos.ids)
        render json: { 'predicted rating': result }
      end

      private

      def serializer
        UploadSerializer
      end

      def upload_params
        params.require(:upload).permit(:user_id, :name, :file)
      end

      def set_upload
        @upload = Upload.find(params[:id])
      end
    end
  end
end
