class SubscriptionsQueries
  class << self
    def subs_group_for_external_links(topic)
      query = <<-SQL
        select distinct subscriptions.id, topic_digests.list_of_5 as links
        from subscriptions, topic_digests, topics
        where subscriptions.topic_id = '#{topic}'
        and topic_digests.topic_id = subscriptions.topic_id
        and topic_digests.list_of_5 is not null
        and topic_digests.created_at between '#{Date.today - 1.year}' and '#{Date.today}'
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a
    end

    def topic_users_emails(topic_id)
      query = <<-SQL
      select subscriptions.id, users.email
      from users, subscriptions
      where subscriptions.topic_id = '#{topic_id}'
      and  subscriptions.id = any(users.subscription_ids);
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end

    def users_group_for_external_links(topic)
      query = <<-SQL
      select users.id as user, subscriptions.id as subid, topic_digests.list_of_5 as links
      from users, subscriptions, topic_digests, topics
      where subscriptions.topic_id = '#{topic}'
      and topic_digests.topic_id = subscriptions.topic_id
      and topic_digests.list_of_5 <> '{}'
      and  subscriptions.id = any(users.subscription_ids)
      and topic_digests.created_at between '#{Date.today - 1.week}' and '#{Date.today}';
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end

    def users_and_extlinks_by_subscription(sub_id)
      query = <<-SQL
      select topic_digests.list_of_5 as links, users.id as user
      from users, subscriptions, topic_digests, topics
      where subscriptions.id = '#{sub_id}'
      and  '#{sub_id}' = any(users.subscription_ids)
      and topic_digests.topic_id = subscriptions.topic_id;
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end

    def show_subs_ratings_per_user(uid)
      query = <<-SQL
      select uploads_ratings as rating
      from users, subscriptions
      where subscriptions.id = any(users.subscription_ids)
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
            .map{ |c| c["rating"] }
            .compact
            .map { |e| sprintf("%0.09f", JSON.parse(e)["info_ratings"].delete("[]")) }
    end
  end
end
