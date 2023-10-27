module Api
  module V1
    class SubscriptionsController < ApplicationController
      before_action :authorize_request
      before_action :set_subscription, except: :create

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

      private

      def subs_params
        params.require(:subscription).permit(:title)
      end

      def set_subscription
        @subscription = Subscription.find(params[:id])
      end
    end
  end
end
