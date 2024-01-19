class Parsers::StoreTopicList
    def self.call(payload, team_id)
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      redis.hmset("links", "listOf5", payload, "teamId", team_id)
      TopicDigest.create!(topic_id: topic_id, list_of_5: payload)
    rescue StandardError => e
      Rails.logger.error(e.message)
      payload
    end
  end
end
