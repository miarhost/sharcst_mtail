require 'twilio-ruby'
module TwilioServices
  class SmsSender < TwilioServices::BaseTwilioService

    def initialize(newsletter)
      @text = newsletter.header
      @users = User.where('subscription_ids IS NOT NULL AND subscription_ids @> ARRAY[?]::varchar[]',
                          [newsletter.subscription_id])
                  .order(email: :asc)
    end

    def twilio(number)
      @twilio =
          client.messages.create(
          body: @text,
          from: sender,
          to: number
        )
    end

    def sender
      @sender = ENV['TWILIO_SMS_SERVICE']
    end
  end
end
