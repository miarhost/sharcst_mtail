 module Api
   module V1
    class CategoriesController < ApplicationController
      before_action :set_category, except: :index

      def store_topic_recommendations
        DiscoServices::TopicSubscriptionsUpdater.call(@category.id)
      end

      def update_recommendations_stats
        stat_creator = Update::FillRecsStatWorker.perform_async(@category.id)
        render json: { result: Sidekiq::Status.get_all(stat_creator) },status: 202
      end

      def show_recommendations_stats
        query = <<-SQL
           select category_stats.category_id, recommendations_stats.uploads_recs,
           recommendations_stats.infos_ratings, recommendations_stats.user_ids
           from recommendations_stats, category_stats
           where category_stats.category_id = #{@category.id}
        SQL
        recs = ActiveRecord::Base.connection.execute(query).to_a.to_json
        render json: recs
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
 end
