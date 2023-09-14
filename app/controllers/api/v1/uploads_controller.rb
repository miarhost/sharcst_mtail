module Api
  module V1
    class UploadsController < ApplicationController
      require 'rest-client'
      include Rails.application.routes.url_helpers
      before_action :authorize_request, except: %i[show load_predictions_for_infos]
      before_action :set_upload

      def webhook_infos
        url = @upload.webhook.url
        response = RestClient.get(url)
        render json: response
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
        @upload.upload_attachment.purge
        render json: { status: :no_content, message: 'Attachment is removed' }, status: 204
      end

      def show
        render json: @upload, serializer: serializer
      end

      def load_prediction_for_infos
        result = DiscoServices::UploadsRecommender.call(@upload.id)
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
