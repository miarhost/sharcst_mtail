class Email::DeliverNewsletter < ApplicationService
  def initialize(users, newsletter)
    @users = users
    @newsletter = newsletter
  end

  def call
    response = []
    @users.each do |user|
      response << NewsletterMailer.with(user: user, newsletter: @newsletter).current_news.deliver_now
    end
    response.join(',')
  end
end
