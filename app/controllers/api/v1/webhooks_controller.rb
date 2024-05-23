module Api
  module V1
    class WebhooksController < ApplicationController
      before_action :authorize_request
      before_action :set_webhook, only: %i[update destroy]

      def slack_notification_for_report
        @webhook = Webhook.where(description: 'slack').first
        result = Webhooks::SlackChannelMessager.call(@webhook.url, permitted_notifier_params[:resource_id])
        render json: { "status": "done", "message": result }
      end

      def messenger_alert_for_admins
        result = TwilioServices::WhatsappSender.call(User.admins, permitted_notifier_params[:tech_alert])
        render json: result
      end

      def parsed_queue_slack_logs
        Webhooks::NewRelicQueueLogs.call
      end

      def create
        @webhook = Webhook.create!(webhook_params.merge(user_id: @current_user&.id))
        render json: { 'status': :created, 'webhook': @webhook }, status: 201
      end

      def update
        @webhook.update!(webhook_params)
        render json: @webhook
      end

      def destroy
        @webhook.destroy!
      end

      def ollama_list_to_parse
        Webhooks::ParseModelResponse.parse(current_user.id)
      end

      private
      def permitted_notifier_params
        params.permit(:resource_id, :id, :tech_alert)
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
