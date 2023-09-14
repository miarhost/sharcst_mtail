module Api
  module V1
    class WebhooksController < ApplicationController
      before_action :authorize_request, only: :slack_notification_for_report
      before_action :set_webhook, only: :slack_notification_for_report

      def slack_notification_for_report
        result = Webhooks::SlackChannelMessager.call(@webhook.url, permitted_notifier_params[:resource_id])
        render json: { "status": "done", "message": result }
      end

      def create
        authorize_request
        @webhook = Webhook.create(webhook_params.merge(user_id: @current_user.id))
        render json: { 'status': :created, 'webhook': @webhook }
      end

      private
      def permitted_notifier_params
        params.permit(:resource_id, :id)
      end

      def webhook_params
        params.require(:webhook).permit(:upload_id, :user_id, :url, :state, :description, :secret)
      end

      def set_webhook
        @webhook = Webhook.find(params[:id])
      end
    end
  end
end
