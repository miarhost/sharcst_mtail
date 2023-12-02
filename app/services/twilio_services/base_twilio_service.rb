class TwilioServices::BaseTwilioService < ApplicationService

  def initialize(*args)
    @text = ''
    @users = []
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


  def twilio(number);end

  def client
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_TOKEN'])
  end

  def sender; end
end
