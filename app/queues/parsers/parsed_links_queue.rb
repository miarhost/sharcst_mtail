class Parsers::ParsedLinksQueue
  class << self
    def exchange_name
      'snickers'
    end

    def queue_name
      'parsed.links'
    end

    def message(id)
      Team.find(id).topic&.title || ''
    end

    def save_to_records(payload, id)
      Parsers::TeamLinksList.call(payload, id)
    end

    def execute(id)
      BasicPublisher.direct_exchange(exchange_name, queue_name, message(id))

      payload = BasicSubscriber.direct_exchange(exchange_name, queue_name)

      save_to_records(payload, id)
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
