require 'disco'
module DiscoServices
  class TeamsSubscriptionsUpdater < ApplicationService
    def call(uid, cid)
      recommender = Disco::Recommender.new
      recs = recommender.fit(data)
      topics.each do |topic|
        topic.update_recommended_subscriptions(recs)
      end
    end

    def data
      DiscoRecommendationsQueries.recs_for_category_teams(cid)
    end

    def topics
      RedisData::UserTopicsForParser.new(uid, Date.today, Date.today - 6.months).additional_topics
    end
  end
end
