
namespace :uploads do
  desc 'Collected per user rates for a week to send'
  task send_weekly_user_rates: :environment do
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    result = {}
    date = Date.today
    date1 = Date.today.prev_week
    weekly =  (date1..date).to_a
    redis.scan_each(match: "exprate*") do |key|
      if weekly.include?(Date.parse(redis.hmget(key, "date")[0]))
        result[key] = { "upload" => redis.hmget(key, "upload"),
                       "rate" => redis.hmget(key, "rate"),
                       "user" => redis.hmget(key, "user") }
      end
    end
    BasicPublisher.direct_exchange('snickers', 'weekly_ind_rates', result.to_json)
  end
end
