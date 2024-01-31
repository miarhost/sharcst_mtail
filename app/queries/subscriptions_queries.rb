class SubscriptionsQueries
  class << self
    def group_for_external_links(topic)
      query = <<-SQL
        select subscriptions.id, topic_digests.list_of_5 as links
        from subscriptions, topic_digests, topics
        where subscriptions.topic_id = '#{topic}'
        and topic_digests.topic_id = subscriptions.topic_id
        and topic_digests.list_of_5 <> '{}'
        and topic_digests.created_at between '#{Date.today - 1.week}' and '#{Date.today}'
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a
    end

    def subs_users_emails(topic_id)
      query = <<-SQL
      select subscriptions.id, users.email
      from users, subscriptions
      where subscriptions.topic_id = '#{topic_id}'
      and  subscriptions.id = any(users.subscription_ids);
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end
  end
end
