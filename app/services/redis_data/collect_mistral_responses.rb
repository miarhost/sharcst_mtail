module RedisData
  class CollectMistralResponses
    extend RedisCache::RedisClient
    def self.call(uid)
      values = []
      redis.scan_each(match: "MistralTopics") do |key|
        if redis.hget(key, "userId") == uid.to_s
          values << { response: redis.hget(key, "value"), date: redis.hget(key, "date").to_time }
        end
      end
      values.select{ |record| record[:date] == values.pluck(:date).max }.first[:response]
    end
  end
end
