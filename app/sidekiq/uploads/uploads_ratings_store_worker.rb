require 'redis'
module Uploads
  class UploadsRatingsStoreWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :updater

    def perform(uploads, ratings)
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      dataset = Hash[uploads.ids.zip(ratings)]
      dataset.each do |k,v|
        redis.set({"upload#{k}"=> "rating#{v}"})
      end
      store result: dataset
    rescue StandardError => e
      store result: e.message
    end
  end
end
