class Parsers::TopicLinksList
  def self.call(payload, id)
    return Errors::Helpers.no_payload unless payload
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.hmset('userLinks', 'links', payload, 'user', id)
    UserLinksProposal.create!(
      user_id: id,
      links: payload,
      origin: 'ollama',
      parsed: true
    )
  end
end
