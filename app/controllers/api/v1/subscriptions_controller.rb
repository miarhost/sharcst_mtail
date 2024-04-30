module Api
  module V1
    class SubscriptionsController < ApplicationController
      before_action :authorize_request
      before_action :set_subscription, except: :create

      def store_topic_recommendations
        location_setup(@current_user) if Rails.env.production?
        return skip_action unless @subscription.topic
        result = DiscoServices::TopicSubscriptionsUpdater
            .call(@current_user.id, @subscription.topic.category.id)

        status = result[:status] ? result[:status] : 200
        render json: result.to_json, status: status
      end

      def create
        @subscription = Subscription.new(subs_params)
        @subscription.save!
        render json: @subscription, status: 201
      end

      def update
        @subscription.update!(subs_params)
        render json: @subscription
      end

      def destroy
        @subscription.destroy!
      end

      def update_stats_preferences
        folder_id = User.find(params[:user_id])&.current_folder.id || current_user.current_folder.id
        DiscoRecommendations::UpdateRecommendedInfos.call(@subscription.id, folder_id)
      end

      private

      def subs_params
        params.require(:subscription).permit(:title, :topic_id, :subs_rate, :subs_rating, :subs_rating_infos)
      end

      def set_subscription
        @subscription = Subscription.find(params[:id])
      end
    end
  end
end
