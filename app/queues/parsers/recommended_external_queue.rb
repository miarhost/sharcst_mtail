class Parsers::RecommendedExternalQueue

  def initialize(user_id, starts, ends)
    @data = JSON.generate(RedisData::UserTopicsForParser.call(user_id, starts, ends))
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
