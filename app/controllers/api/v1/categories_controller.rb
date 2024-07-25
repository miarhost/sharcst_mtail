 module Api
   module V1
    class CategoriesController < ApplicationController
      before_action :set_category, except: :index

      def store_topic_recommendations
        DiscoServices::TopicSubscriptionsUpdater.call(@category.id)
        Update::FillRecGroupWorker.perform_later(@category.id)
      end

      def update_recommmendations_stats; end

      private

      def set_category
        Category.find(params[:id])
      end
    end
  end
 end
