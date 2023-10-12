module Api
  module V1
    class NewslettersController < ApplicationController
      before_action :authorize_request
      before_action :set_newsletter

      def sms_users_newsletter
        authorize @newsletter
        twilio_response = TwilioServices::SmsSender.call(@newsletter)

        render json: twilio_response
      end

      private

      def set_newsletter
        @newsletter = Newsletter.find(params[:id])
      end
    end
  end
end
