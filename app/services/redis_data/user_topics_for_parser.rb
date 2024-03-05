module RedisData
  class UserTopicsForParser < ApplicationService
    def initialize(user_id, starts, ends)
      @user_id = user_id
      @starts = starts
      @ends = ends
    end

    def call
      from_exprates_collected
    end

    private

    def from_exprates_collected
      result = {}
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      redis.scan_each(match: '*expdate*') do
        date = redis.hget(key, 'date').delete("-")
        date.prepend("0") if date.length < 8
        if redis.hget(key, 'user') == @user_id.to_s && (@starts..@ends).to_a.include?(Date.strptime(date, "%d%m%Y"))
          upload = Upload.find(redis.hget(key, 'upload').to_i)
          topic = Topic.find(upload.topic_id)&.name.capitalize
          result['rate'] = redis.hget['rate'], result['topic'] = topic, result['user'] = @user_id
        end
      end
      result['subtopics'] = from_recs_by_period
      result
    end

    def from_recs_by_period
      records = Upload.for_period(@starts, @ends).limit(30)
      result = DiscoServices::TodaysItemsRecommender.call(User.find(@user_id), records)
      recs = Upload.where(id: result.map{ |x| x[:item_id] })
      topics = Topic.where(id: recs.pluck(:topic_id)).pluck(:title).compact&.map(&:capitalize).join
    end
  end
end
