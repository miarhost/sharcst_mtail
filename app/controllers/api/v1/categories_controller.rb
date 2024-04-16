 module Api
   module V1
    class CategoriesController < ApplicationController
      before_action :set_category, except: :index
      def store_topic_recommendations
        TopicSubscriptionsUpdater.call(@category.id)
      end

      def set_category
        Category.find(params[:id])
      end
    end
  end
 end
