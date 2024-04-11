
module RedisCache
  class  < ApplicationService
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
    end

    def call
     redis.hget(record_found, 'refreshToken') if ttl_valid?(record_found)
    end
  end
end
