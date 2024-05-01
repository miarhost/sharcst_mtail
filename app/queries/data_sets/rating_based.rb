module DataSets
  class RatingBased
    class << self

      def target_topic_max_rated_by_team(tid)
        query = <<-SQL
        select distinct uploads.id, max(uploads.rating)
        from uploads, teams
        where uploads.topic_id = teams.topic_id
        and teams.id = #{tid}
        group by uploads.id, uploads.rating
        limit 3;
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a
      end

      def target_topic_max_rated_by_subscription(sid)
        query = <<-SQL
        select distinct topics.id as user_id, uploads.id as item_id, max(uploads.rating) as score
        from uploads, subscriptions, topics
        where uploads.topic_id = subscriptions.topic_id
        and subscriptions.id = #{sid}
        and topics.id = uploads.topic_id
        group by uploads.id, topics.id, uploads.rating
        limit 3;
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a
      end
    end
  end
end
