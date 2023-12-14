class Uploads::IndRatesCollectingWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: 'uploads', retry: 2, backtrace: 3

  def perform(payload)
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.set("#{Time.now}", {"rate": "#{payload}"})
    store result: {"#{Time.now}": "updated"}.to_json
  rescue StandardError => e
    store result: e.message
    Rails.logger.error(e.message)
  end
end
