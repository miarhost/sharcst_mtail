class NewsletterMailer < ApplicationMailer
  layout 'newsletter_mailer'

  def current_news
    @user = params[:user]
    @newsletter = params[:newsletter]

    mail(to: @user.email, subject: @newsletter.header)
  end
end
