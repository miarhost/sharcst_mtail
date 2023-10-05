module Api
  module V1
    class UploadsInfosController < ApplicationController
      before_action :authorize_request, except: %i[index show]
      before_action :set_info, except: %i[index remove_report]

      def index
        filter = filter_params[:search].present? ? filter_params[:search] : ''
        uploads_infos = SelectUploadsInfos.new.call(filter)
        uploads_infos_paginated = paginate_collection(uploads_infos, params[:page], 5)
        predictions = UploadsInfos::PredictionRateWorker.perform_in(1.seconds, uploads_infos.ids)
        PredictionsDeliverQueue.new(uploads_infos, predictions).publish

        render json: uploads_infos_paginated, each_serializer: UploadsInfosSerializer, root: false
      end

      def show
        render json: @uploads_info, serializer: UploadsInfoSerializer
      end

      def update
        @uploads_info.update!(permitted_params)
        render json: @uploads_info, serializer: UploadsInfoSerializer
      end

      def generate_report
        render json: GenerateUploadsInfoReport.call(@uploads_info.id)
      end

      def remove_report
        uploads_info_attachment = UploadsInfoAttacment.find_by!(id: params[:attachment_id])
        uploads_info_attachment.purge
        uploads_info_attachment.destroy!
      end

      def update_streaming_infos
        render json: UpdateStreamingInfos.call(@uploads_info.id)
      end

      private

      def set_info
        @uploads_info = UploadsInfo.find(params[:id])
      end

      def permitted_params
        params.require(:uploads_info).permit(:name, :protocol, :upload_id, :user_id, :number_of_seeds, :description,
                                             :duration, :provider, :streaming_infos)
      end

      def filter_params
        params[:filter] ? params.require[:search].permit(:number_of_seeds, :name, :protocol, :user_id) : {}
      end
    end
  end
end
