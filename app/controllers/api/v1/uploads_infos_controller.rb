module Api
  module V1
    class UploadsInfosController < ApplicationController
      before_action :authorize_request, except: %i[index show deliver_predictions]
      before_action :set_info, except: %i[index remove_report deliver_predictions]

      def index
        uploads_infos_paginated = paginate_collection(uploads_infos, params[:page], 5)
        render json: uploads_infos_paginated, each_serializer: UploadsInfosSerializer, root: false
      end

      def deliver_predictions
        predictions = DiscoServices::UploadsRecommender.call(uploads_infos.ids)
       predictions_array = predictions.delete('[]').split(', ').map(&:to_f) if predictions
       render json: (Hash[uploads_infos.pluck(:name).zip([predictions_array])])
       MappedPredictionsDeliverQueue.new(uploads_infos, predictions_array).execute
      end

      def show
        render json: @uploads_info, serializer: UploadsInfoSerializer
      end

      def update
        @uploads_info.update!(permitted_params)
        render json: @uploads_info, serializer: UploadsInfoSerializer
      end

      def generate_report
        render json: Reports::UploadsMonthlyData.call(@uploads_info.id)
      end

      def remove_report
        uploads_info_attachment = UploadsInfoAttacment.find_by!(id: params[:attachment_id])
        uploads_info_attachment.purge
        uploads_info_attachment.destroy!
      end

      def update_streaming_infos
        render json: Updaters::UpdateStreamingInfos.call(@uploads_info.id)
      end

      private

      def set_info
        @uploads_info = UploadsInfo.find(params[:id])
      end

      def permitted_params
        params.require(:uploads_info).permit(:name, :rating, :date, :log_tag, :upload_id, :user_id,
                                             :upl_count, :down_count, :description, :duration, :provider, :streaming_infos)

      end

      def filter_params
        params[:filter] ? params.require[:search].permit(:rating, :name, :date, :user_id, :log_tag) : {}
      end

      def filter
        filter_params[:search].present? ? filter_params[:search] : ''
      end

      def uploads_infos
        SelectRecords.new(UploadsInfo).call(filter)
      end
    end
  end
end
