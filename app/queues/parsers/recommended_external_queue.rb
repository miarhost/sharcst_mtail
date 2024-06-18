class Parsers::RecommendedExternalQueue

  def initialize(data, user_id)
    @data = JSON.generate(data)
  end

  def exchange_name
    'snickers'
  end

  def queue_name
    'parsing.topics'
  end


  def execute
    status = {}
    BasicPublisher.direct_exchange(exchange_name, queue_name, @data)
    info_message = "request for parser sent at #{Time.now}"
    status[:result] = JSON.parse(@data)
    status[:message] = info_message
    Rails.logger.info(info_message).to_json
    status
  rescue StandardError => e
    Rails.logger.error(e.message)
    status[:errors] = e.message
    status
  end
end
