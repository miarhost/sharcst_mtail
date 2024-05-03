require 'disco'
module DiscoServices
  class TeamsSubscriptionsUpdater < ApplicationService

    def initialize(uid, cid)
      @uid, @cid = uid, cid
    end

    def call
      return no_training_data if data.empty?
      recommender = Disco::Recommender.new
      recs = recommender.fit(data)
      topics.each do |topic|
        topic.update_recommended_subscriptions(data)
      end
    end

    private

    def data
      DiscoRecommendationsQueries
        .recs_for_category_teams(@cid)
        .map(&:symbolize_keys)
    end

    def topics
      RedisData::UserTopicsForParser
        .new(@uid, Date.today, Date.today - 6.months)
        .additional_topics
    end
  end
end
