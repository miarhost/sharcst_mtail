
module RedisCache
  class FetchRt < ApplicationService
    include RedisClient

    def ttl_valid?(key)
      redis.hget(key, "ttl") >= Time.now
    end

    def call(headers, user_id)
      result = []
      redis.scan_each(match: "#{headers}") do |key|
        if redis.hget(key, "userId") == user_id && ttl_valid?(key)
          result << redis.hget(key, "refreshToken")
        end
      end
      result[0]
    end
  end
end
