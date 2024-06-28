class Parsers::TopicLinksList
  def self.call(payload, id)
    return Errors::Helpers.no_payload unless payload
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.hmset('userLinks', 'links', payload, 'user', id)

    record = UserLinksProposal
      .where('user_id = ? and origin = ?', id, "ollama")
      .last

    record.update!(links: payload, parsed: true)
    record
  end
end
