
namespace :uploads do
  desc 'Collected per user rates for a week to send'
  task send_weekly_user_rates: :environment do
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    result = []
    redis.scan_each(match: "*#{Date.today}*") do |key|
      result <<  redis.get(key)
    end
    BasicPublisher.direct_exchange('snickers', 'weekly_ind_rates', result.to_json)
  end
end
