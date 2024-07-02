require 'redis'
class PopulateUidsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options queue: :updater
  def redis
    @redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
  end

  def ids
    RecordsForPeriod.new(User, Date.today.prev_month, Date.today).ids
  end

  def perform
    incr = []
    ids.each do |id|
      uid  = SecureRandom.uuid
      redis.set("#{id}user", {'uid': uid, 'date': Time.now.strftime("%y-%m-%d")}.to_json)
    end
    redis.scan_each(match: '*user') do |key|
      incr <<  redis.get(key)
    end

    store result: incr.join(',')
  rescue StandardError => e
    store result:  e.message
  end
end
