class Parsers::ParsedLinksQueue
  class << self
    def exchange_name
      'snickers'
    end

    def queue_name
      'parsed.links'
    end

    def save_to_records(payload, id)
      Parsers::TeamLinksList.call(payload, id)
    end

    def execute(id)

      payload = Subscriber.direct_exchange(exchange_name, queue_name)

      record = save_to_records(payload, id)
      record
     rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
