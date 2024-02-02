class Newsletters::WeeklyTopicLinks
  def self.call(topic)

    SubscriptionsQueries.subs_group_for_external_links(topic).each do |pair|
      newsletter = Newsletter.create!(subscription_id: pair['id'],
                         body: pair['links'].delete("{}"),
                         date: Time.now,
                         name: 'Weekly Resources',
                         header: 'Weekly Top 5 Links by Topic',
                         tag: 'external links',
                         ad_type: 1
                         )

    end
  end
end
