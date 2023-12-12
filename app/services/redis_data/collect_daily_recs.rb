module RedisData
  class CollectDailyRecs < ApplicationService
    def initialize(date)
      @date = date
    end

    def call
      result = []
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      redis.scan_each(match: "*user*") do |key|
        set = redis.get(key)
        result << "#{key}: "+ set if set.include?(@date.strftime)
      end
      result
    end
  end
end
