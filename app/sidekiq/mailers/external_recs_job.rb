class Mailers::ExternalRecsMessengerJob
  include Sidekiq::Worker

  sidekiq_options queue: :mailer, retry: false, backtrace: 1

  def perform(nid)
    newsletter = Newsletter.find(nid)
      ExternalRecsMailer
        .with(email: user.email, newsletter: newsletter)
        .weekly_links
        .deliver_now
    end
  end

  def self.mail_queue
    User.have_subscription(subscription_id).find_each do |user|
      perform_async(nid)
    end
  end
end
