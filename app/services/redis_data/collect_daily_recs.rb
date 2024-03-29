module RedisData
  class CollectDailyRecs < ApplicationService
    include RedisCache::RedisClient
    def initialize(date)
      @date = date
    end

    def call
      result = []
      redis.scan_each(match: "*user*") do |key|
        if redis.type(key) == "string"
           set = redis.get(key)
           result << set if set.include?(@date.strftime)
        elsif redis.type(key) == "hash"
          set = redis.hgetall(key)
          result << set if set["date"] == @date.strftime("%d%m%Y") || @date.strftime("%Y%m%d")
        end
      end
      result
    end
  end
end
