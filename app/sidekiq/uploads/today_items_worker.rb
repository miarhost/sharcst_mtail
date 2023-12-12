class Uploads::TodayItemsWorker
include Sidekiq::Worker
include Sidekiq::Status::Worker

sidekiq_options queue: :updater


  def perform(user_id, preferences)
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    redis.set("user-#{user_id}", {, "date" => "#{Date.today}", "recommendations" => "#{preferences}"})
  end
end
