module Messengers
  class ExternalRecsMessageJob
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    sidekiq_options queue: :messengers, retry: 1, backtrace: 4

    def perform(nid)
      newsletter = Newsletter.find(nid)
      users = User.have_subscription(newsletter.subscription_id)
      bulk_process = TwilioServices::WhatsappSender.call(users, newsletter.body)
      store result: bulk_process
    end
  end
end
