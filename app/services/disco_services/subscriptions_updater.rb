require 'disco'
module DiscoServices
  class SubscriptionsUpdater < ApplicationService
    def self.call(uid, cid)
      recommender = Disco::Recommender.new
      data = DiscoRecommendationsQueries.recs_for_category_teams(cid)
      recs = recommender.fit(data)
      topics = RedisData::UserTopicsForParser.new(uid, Date.today, Date.today - 6.months).additional_topics
      topics.each do |topic|
        topic.update_recommended_subscriptions(recs)
      end
    end
  end
end
