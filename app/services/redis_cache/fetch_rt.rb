
module RedisCache
  class FetchRt < ApplicationService
    include RedisClient
    def initialize(token)
      @token = token
    end

    def ttl_valid?(key)
      redis.hget(key, "ttl") >= Time.now
    end

    def call
      token = redis.keys(@token).first if @token
      redis.hget(token, 'refreshToken')
    end
  end
end
