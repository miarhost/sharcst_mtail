
namespace :uploads do
  desc 'Collected per user rates for a week to send'
  task send_weekly_user_rates: :environment do
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    result = {}
    date = Date.today.strftime("%d%m%Y").to_i
    date1 = Date.today.prev_week.strftime("%d%m%Y").to_i
    weekly =  (date1..date).to_a
    redis.scan_each(match: "exprate*") do |key|
      if weekly.include?(redis.hmget(key, "date"))
        result[key] = {redis.hmget(key, "upload") => redis.hmget(key, "rate")}
      end
    end
    BasicPublisher.direct_exchange('snickers', 'weekly_ind_rates', result.to_json)
  end
end
