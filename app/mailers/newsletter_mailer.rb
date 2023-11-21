class NewsletterMailer < ApplicationMailer
  layout 'current_news'

  def current_news
    @user = params[:user]
    @newsletter = params[:newsletter]

    mail(to: @user.email, subject: @newsletter.header)
    Rails.logger.info("Delivered to #{@user.email}")
  rescue StandardError => e
    Rails.logger.error("Delivery failed: #{error.message}")
  end
end
