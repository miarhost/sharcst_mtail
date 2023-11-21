module Api
  module V1
    class NewslettersController < ApplicationController
      before_action :authorize_request
      before_action :set_newsletter, except: %i[create monthly_uploads_newsletter]

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

      def update
        authorize @newsletter
        @newsletter.update!(newsletter_params)
        NewsletterMailer.with(user: @current_user, newsletter: @newsletter).current_news.deliver_now
        render json: @newsletter, status: 200
      end

      def monthly_uploads_newsletter
        @newsletter = Newsletters::MonthlyUploadsAdminsNewsletter.call
        delivery = Email::DeliverNewsletter.call(User.admins, @newsletter)
        render json: [@newsletter, { 'delivery_status': delivery }], status: 201
      end

      def email_users_newsletter
        authorize @newsletter
        response = Email::DeliverNewsletter.call(User.admins, @newsletter)
        render json: { 'delivery_status': response }
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
