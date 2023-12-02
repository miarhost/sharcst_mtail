require 'twilio-ruby'
module TwilioServices
  class WhatsappSender < TwilioServices::BaseTwilioService

    def initialize(users, text)
      @users = users
      @text = text
    end

    private

    def twilio(number)
      @twilio =
          client.messages.create(
          body: @text,
          from: "whatsapp:#{sender}",
          to: "whatsapp:#{number}"
        )
    end
  end
end
