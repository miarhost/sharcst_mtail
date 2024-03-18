class Parsers::ParsedTopicQueue < Parsers::ParsedLinksQueue
  class << self
    def queue_name
      'parsed.topics'
    end

    def message(id)
      { user: id, date: Time.now }.to_json
    end

    def save_to_records(payload, id)
      Parsers::TopicLinksList.call(payload, id)
    end
  end
end
