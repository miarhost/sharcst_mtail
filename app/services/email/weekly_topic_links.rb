class Email::WeeklyTopicLinks
  def self.call(topic)
    links = SubscriptionsQueries.group_for_external_links(topic)
    body = []
    links.map{ |x| body << x["links"].delete("{}") }
    SubscriptionsQueries.subs_users_emails(topic).each do |pair|
      newsletter = Newsletter.create!(subscription_id: pair['id'],
                         body: body,
                         date: Time.now,
                         name: 'Weekly Resources',
                         header: 'Weekly Top 5 Links by Topic'
                         )

      ExternalRecsMailer.with(email: pair['email'], newsletter: newsletter)
                        .weekly_links
                        .deliver_now
    end
  end
end
