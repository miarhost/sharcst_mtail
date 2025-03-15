
module RedisCache
  class FetchRt < ApplicationService
    include RedisClient
    def initialize(token)
      @token = token
    end

    def record_found
     redis.keys(@token).first if @token
    end

    def ttl_valid?(key)
      ttl = redis.hget(key, "ttl").to_i
      redis.hget(key, "ttl") >= Time.now.to_i
    rescue Redis::CommandError => e
      Rails.logger.error "Redis::CommandError: #{e.message} on key #{key}"
    end

    def call
     redis.hget(record_found, 'refreshToken') if ttl_valid?(record_found)
    end
  end
end
