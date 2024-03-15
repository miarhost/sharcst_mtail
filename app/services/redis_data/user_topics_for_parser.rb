module RedisData
  class UserTopicsForParser < ApplicationService
    def initialize(user_id, starts, ends)
      @user_id = user_id
      @starts = starts.to_date
      @ends = ends.to_date
    end

    def call
      from_exprates_collected
    end

    private

    def from_exprates_collected
      result = {}
      redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
      redis.scan_each(match: '*exprate*') do |key|
        date = redis.hget(key, 'date').delete("-")
        date.prepend("0") if date.length < 8
        if redis.hget(key, 'user') == @user_id.to_s && Date.strptime(date, "%d%m%Y").between?(@starts, @ends)
          upload = Upload.find(redis.hget(key, 'upload').to_i)
          topic = Topic.find_by(id: upload.topic_id)
          title = topic ? topic.title.delete(" ") : 'undefined'

          result['rate'] = redis.hget(key, 'rate')
          result['topics'] = [] << title
          result['user'] = @user_id
        end
      end
      additional_topics.blank? ? result : result.merge({'subtopics' => additional_topics})
    end

    def additional_topics
      records = Upload.for_period(@starts, @ends).limit(30)
      recommender = DiscoServices::TodaysItemsRecommender.call(User.find(@user_id), records)
      rec_uploads = Upload.where(id: recommender.pluck(:item_id))
      topics = Topic.where(id: rec_uploads.pluck(:topic_id))
                    .pluck(:title)
                    .compact
                    .map{ |x| x.delete(" ") }
                    .join(', ')
    rescue StandardError => e
      Rails.logger.error(e.message)
       return []
    end
  end
end
