module Api
  module V1
    class DiscoRecommendationsController < ApplicationController
      before_action :authorize_request

      def queue_recommendations_for_user
        data = DiscoServices::UserRecommender.call(@current_user.id)
        StoredPredictionsDeliverQueue.new(data.to_json).publish
        render json: data
      end

      def queue_recommendations_for_upload_period; end

      def queue_recommendations_for_logs_period; end
    end
  end
end
