module DiscoServices
  class TopicSubscriptionsUpdater < TeamsSubscriptionsUpdater
    def data
      result = []
      topics.each do |topic|
       result << SubscriptionsQueries.subs_group_for_external_links(topic).to_a
      end
      result.flatten
    end

    def topics
      Category.find(@cid)&.topics.pluck(:id)
    end
  end
end
