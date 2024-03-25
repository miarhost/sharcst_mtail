module Api
  module V1
    class DiscoRecommendationsController < ApplicationController
      before_action :authorize_request

      def queue_recommendations_for_user
        data = DiscoServices::UserRecommender.call(@current_user)
        StoredPredictionsDeliverQueue.new(data.to_json).execute
        store_ratings = Uploads::UploadsRecommendationsStoreWorker.
                          perform_async({'user' => @current_user.id, 'ratings' => data[:result]}.to_json)
        sleep 1
        job_status = Sidekiq::Status.get(store_ratings, :status)

        job_result = Sidekiq::Status.get(store_ratings, :result)
        @current_user.update_recommended_uploads(job_result)
        render json: [data, { 'status': job_status, result: job_result }]
      end

      def queue_daily_recommendations_for_items
        records = Upload.for_period(Date.today.beginning_of_day.prev_month, Date.today.end_of_day)
        result = DiscoServices::TodaysItemsRecommender.call(@current_user, records)
        Uploads::TodayItemsWorker.perform_async(@current_user.id, result.to_json)
        preferences = []
        result.each do |hash|
          preferences << { 'item': Upload.find(hash[:item_id])&.name, 'score': (hash[:score] * 100).round(2) }
        end
        render json: preferences.to_json
      end

      def queue_importance_values_lists
        payload = DiscoRecommendationsQueries
                    .implicit_helper_values_top_list.to_json

        ImportanceListDeliverQueue.execute(payload)
      end

      def update_subscriptions_recs
        DiscoServices::SubscriptionsUpdater.call(@current_user.id, params[:category_id])
      end
    end
  end
end
