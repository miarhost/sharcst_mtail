namespace :redis_cache do
  desc 'Remove tokens with expired ttl'
  task remove_unused_tokens: :environment do
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.scan_each(match: 'ey*') do |key|
      ttl = redis.hmget(key, 'ttl')
     if Time.now.to_i > ttl.to_i
       redis.hdel(key)
     end
    end
  end
end
