module DiscoServices
  class TopicSubscriptionsUpdater < TeamsSubscriptionsUpdater
    def data
     DataSets::Subscriptions.subs_of_users_of_rated_uploads
    end

    def topics
      Category.find(@cid)&.topics.pluck(:id)
    end
  end
end
