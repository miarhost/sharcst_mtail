require 'twilio-ruby'
class TwilioServices::SmsSender < ApplicationService

  def initialize(newsletter)
    @text = newsletter.header
    @numbers = User.where('subscription_ids IS NOT NULL AND subscription_ids @> ARRAY[?]::varchar[]', [newsletter.subscription_id])
                   .pluck(:number)
  end

  def call
    @numbers.each do |number|
      message = client.messages.create(
        body: @text,
        from: sender,
        to: number
      )
    rescue Twilio::REST::RestError => e
      { "message": e.message }
    end
  end

  private

  def client
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_TOKEN'])
  end

  def sender
    @sender = ENV['TWILIO_SMS_SERVICE']
  end
end
