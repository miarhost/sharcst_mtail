module RedisCache
  class SaveRt < ApplicationService
    include RedisClient
    def call(token, refresh_token, user_id)
      redis.hmset(token, 'userId', user_id.to_s, 'refreshToken', refresh_token, 'ttl', ttl)
    end

    def ttl
      Time.now + ENV['REFRESH_TTL']
    end
  end
