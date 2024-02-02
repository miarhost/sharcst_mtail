class Mailers::ExternalRecsJob
  include Sidekiq::Worker

  sidekiq_options queue: :mailer, retry: false, backtrace: 1

  def perform(nid, uid)
    ExternalRecsMailer
      .with(uid: uid, nid: nid)
      .weekly_links
      .deliver_now
  end

  def self.mail_queue(nid)
    User.have_subscription(Newsletter.find(nid).subscription_id).each do |user|
      perform_async(nid, user.id)
    end
  end
end
