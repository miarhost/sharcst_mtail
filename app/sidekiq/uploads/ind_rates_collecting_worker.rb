class Uploads::IndRatesCollectingWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: :updater, retry: 1, backtrace: 3

  def perform(payload)
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    uid = JSON.parse(payload)['user_id']
    rate = JSON.parse(payload)['rating']
    date = Date.today.strftime('%d-%m-%Y')
    upload = JSON.parse(payload)['upload_id']
    redis.hmset("exprate#{date}", "date", date, "rate", rate, "user", uid, "upload", upload )
    store result: { rate: rate, user: uid }
    Sidekiq.logger.info "Rate is updated"
  rescue StandardError => e
    store result: "Failed to create exprate" + e.message
    Sidekiq.logger.error( e.message)
  end
end
