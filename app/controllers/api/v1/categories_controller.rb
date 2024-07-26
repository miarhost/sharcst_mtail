 module Api
   module V1
    class CategoriesController < ApplicationController
      before_action :set_category, except: :index

      def store_topic_recommendations
        DiscoServices::TopicSubscriptionsUpdater.call(@category.id)
      end

      def update_recommendations_stats
        stat_creator = Update::FillRecGroupWorker.perform_async(@category.id)
        sleep 1
        render json: { result: Sidekiq::Status.get_all(stat_creator) }
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
 end
