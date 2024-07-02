module MistralResponses
  class RecommendedFieldsWorker
    include RedisCache::RedisClient
    include Sidekiq::Worker

    sidekiq_options queue: :predictions

    def perform(user_id)
      begin
      stream = Webhooks::SuggestedCategories.call(user_id)
      rescue OpenURI::HTTPError => e
        Rails.logger.error(e.message)
      ensure
        redis.hmset("MistralTopics", "value", stream, "userId", user_id, "date", Time.now)
      end
    end
  end
end
