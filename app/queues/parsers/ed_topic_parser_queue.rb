class Parsers::EdTopicParserQueue
  class << self
    def exchange_name
      'snickers'
    end

    def queue_name
      'parsing'
    end

    def execute(message)
      BasicPublisher.direct_exchange(exchange_name, queue_name, message.to_json)
      Rails.logger.info("Requested parsing from#{message}")
      {'success': 'in queue'}
    rescue => e
      Rails.logger.error("#{e.message}")
      {"error": "#{e.message}"}
    end
  end
end
