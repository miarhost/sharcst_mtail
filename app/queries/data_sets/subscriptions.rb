module DataSets
  class Subscriptions
    class << self
      def subs_of_users_of_rated_uploads
        query = <<-SQL
        select subscriptions.id as item_id, users.id as user_id, subscriptions.subs_rating as score
        from subscriptions, users, uploads, topics
        where uploads.topic_id = topics.id
        and uploads.user_id = users.id
        and uploads.rating > 3
        and subscriptions.id = any(users.subscription_ids);
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a.map(&:symbolize_keys)
      end
    end
  end
end
