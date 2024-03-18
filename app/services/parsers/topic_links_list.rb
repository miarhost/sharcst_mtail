class Parsers::TopicLinksList
  def self.call(payload, id)
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.hmset('userLinks', 'links', payload, 'user', id)
  end
end
