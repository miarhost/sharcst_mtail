module Api
  module V1
    class NewslettersController < ApplicationController
      before_action :authorize_request
      before_action :set_newsletter, except: :create

      def sms_users_newsletter
        authorize @newsletter
        twilio_response = TwilioServices::SmsSender.call(@newsletter)

        render json: twilio_response
      end

      def create
        @newsletter = Newsletter.new(newsletter_params)
        @newsletter.save!
        NewsletterMailer.with(user: @current_user, newsletter: @newsletter).current_news.deliver_now
        render json: @newsletter, status: 201
      end

      private

      def set_newsletter
        @newsletter = Newsletter.find(params[:id])
      end

      def newsletter_params
        params.require(:newsletter).permit(:header, :body, :name, :uploads_info_id, :date, :subscription_id)
      end
    end
  end
end
