 module Api
   module V1
    class CategoriesController < ApplicationController
      include SwagDocs::CategoriesDoc
      before_action :authorize_request, except: :show_recommendations_stats
      before_action :set_category
      def store_topic_recommendations
        DiscoServices::TopicSubscriptionsUpdater.call(@category.id)
      end

      def update_recommendations_stats
        stat_creator = Update::FillRecsStatWorker.perform_async(@category.id)
        render json: { result: Sidekiq::Status.get_all(stat_creator) },status: 202
      end

      def show_recommendations_stats
        recs = CategoryStat.joins(:recommendations_stat).where(category_stats: {category_id: @category.id})
        render json: recs, each_serializer: CatStatWithRecsSerializer
      end
      private

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
 end
