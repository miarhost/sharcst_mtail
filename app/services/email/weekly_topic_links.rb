class Email::WeeklyTopicLinks
  def self.call
    body = SubscriptionsQueries.group_for_external_links(topic)
    SubscriptionsQueries.subs_users_emails(topic).each do |pair|
      newsletter = Newsletter.create!(subscription_id: pair['id'],
                         body: body,
                         date: Date.today,
                         name: 'Weekly Resources',
                         header: 'Weekly Top 5 Links by Topic'
                         )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e.message)
      ExternalRecsMailer.with(email: pair['email'], newsletter: newsletter)
                        .weekly_links
                        .deliver_now
    end
  end
end
