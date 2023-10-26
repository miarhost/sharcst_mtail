module Api
  module V1
    class DiscoRecommendationsController < ApplicationController
      before_action :authorize_request

      def queue_recommendations_for_user
        data = DiscoServices::UserRecommender.call(@current_user)
        StoredPredictionsDeliverQueue.new(data.to_json).publish
        store_ratings = Uploads::UploadsRatingsStoreWorker.perform_async([@current_user.uploads, data].to_json)
        job_status = Sidekiq::Status.get(store_ratings, :status)
        render json: [data, { "status": job_status }]
      end

      def queue_recommendations_for_upload_period; end

      def queue_recommendations_for_logs_period; end
    end
  end
end
