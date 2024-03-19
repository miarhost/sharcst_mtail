class Parsers::TeamLinksList
  def self.call(payload, team_id)
    if payload
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      redis.hmset("links", "listOf5", payload.take(5), "teamId", team_id)
      topic_id = Team.find(team_id)&.topic_id
      TopicDigest.create!(topic_id: topic_id, list_of_5: payload.split)
    else
      Rails.logger.info('No Records')
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
  end
end
