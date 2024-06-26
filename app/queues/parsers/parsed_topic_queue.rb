class Parsers::ParsedTopicQueue < Parsers::ParsedLinksQueue
  class << self

    def save_to_records(payload, id)
      Parsers::TopicLinksList.call(payload, id)
    end
  end
end
