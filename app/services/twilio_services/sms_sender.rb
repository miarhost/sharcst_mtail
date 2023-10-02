require 'twilio-ruby'
class TwilioServices::SmsSender < ApplicationService

  def initialize(newsletter)
    @text = newsletter.header
    @users = User.where('subscription_ids IS NOT NULL AND subscription_ids @> ARRAY[?]::varchar[]',
                        [newsletter.subscription_id])
                 .order(email: :asc)
  end

  def call
    result = []
    @users.each do |user|
      sent = twilio(user.phone_number)
      result <<  { "status": sent.status, "body": sent.body }
    rescue Twilio::REST::TwilioError => e
      raise Errors::ErrorsHandler::TwilioApiError, e
    rescue Twilio::REST::RestError => e
      raise Errors::ErrorsHandler::TwilioRestError, e.message
      result << { "message": e.message }
    end
    result
  end

  private

  def twilio(number)
    @twilio =
        client.messages.create(
        body: @text,
        from: sender,
        to: number
      )
  end

  def client
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_TOKEN'])
  end

  def sender
    @sender = ENV['TWILIO_SMS_SERVICE']
  end
end
