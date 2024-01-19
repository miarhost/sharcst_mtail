class Parsers::ParsedReceiverQueue
  class << self
    def exchange_name
      'snickers'
    end

    def queue_name
      'parsed'
    end

    def execute(team_id)
      payload = BasicSubscriber.direct_exchange(exchange_name, queue_name)
      Parsers::StoreTopicList.call(payload, team_id)
    rescue StandardError => e
      Rails.logger.error(e.backtrace)
    end
  end
end
