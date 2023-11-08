module Api
  module V1
    class DiscoRecommendationsController < ApplicationController
      before_action :authorize_request

      def queue_recommendations_for_user
        data = DiscoServices::UserRecommender.call(@current_user)
        StoredPredictionsDeliverQueue.new(data.to_json).execute
        store_ratings = Uploads::UploadsRatingsStoreWorker.
                          perform_async({'user' => @current_user.id, 'ratings' => data[:result]}.to_json)
        sleep 1
        job_status = Sidekiq::Status.get(store_ratings, :status)

        job_result = Sidekiq::Status.get(store_ratings, :result)
        render json: [data, { 'status': job_status, result: job_result }]
      end

      def queue_recommendations_for_upload_period; end

      def queue_recommendations_for_logs_period; end
    end
  end
end
