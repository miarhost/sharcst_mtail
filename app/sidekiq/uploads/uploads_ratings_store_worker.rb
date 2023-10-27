require 'redis'
module Uploads
  class UploadsRatingsStoreWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :updater

    def perform(ratings_hash)
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      user = User.find(JSON.parse(ratings_hash)['user'])
      dataset = Hash[user.uploads.ids.zip(JSON.parse(ratings_hash)['ratings'])]
      dataset.each do |k,v|
        redis.set("user-#{user.id}", {"upload#{k}"=> "rating#{v}"})
      end
      store result: dataset.to_json
    rescue StandardError => e
      store result: e.message
      Rails.logger.error(e.message)
    end
  end
end
