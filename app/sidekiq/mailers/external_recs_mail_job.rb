class Mailers::ExternalRecsMailJob
  include Sidekiq::Worker

  sidekiq_options queue: :messengers, retry: false, backtrace: 1

  def perform(nid, uid)
    ExternalRecsMailer
      .with(uid: uid, nid: nid)
      .weekly_links
      .deliver_now
  end

  def self.bulk_mail(nid)
    User.have_subscription(Newsletter.find(nid).subscription_id).each do |user|
      perform_async(nid, user.id)
    end
  end
end
