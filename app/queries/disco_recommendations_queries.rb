class DiscoRecommendationsQueries
  class << self

    #------- query results of recs objects saved to pg

    def scores_for_uploads(id)
      query = <<-SQL
        select disco_recommendations.score, uploads.name
        from disco_recommendations, uploads
        where disco_recommendations.item_type = 'upload'
        and disco_recommendations.item_id = #{id};
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def users_subs_rates_for_teams(uid)
      subids = "#{User.find(uid).subscription_ids.map(&:to_i)}".delete("[]")
      query = <<-SQL
      select disco_recommendations.score, teams.tag, subscriptions.title
      from disco_recommendations, users, teams, subscriptions
      where disco_recommendations.subject_type = 'user'
      and (disco_recommendations.subject_id = #{uid}
      or subscriptions.id in(#{subids}))
      and users.team_id = teams.id;
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def recs_for_category_teams(cid)
      query = <<-SQL
      select disco_recommendations.item_id, users.email
      from disco_recommendations, teams, users, categories
      where disco_recommendations.subject_id = users.id
      and users.team_id = teams.id
      and teams.category_id = #{cid};
      SQL
      ActiveRecord::Base.connection.execute(query)
    end

    def daily_recs_for_team(tid)
      query = <<-SQL
      select item_id, score
      from disco_recommendations
      where subject_id = #{tid} and subject_type = 'team'
      and created_at between '#{Date.yesterday}' and '#{Date.today}';
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end

    def last_team_recs
      query = <<-SQL
      select subject_id as team_id, item_id as upload_id
      from disco_recommendations
      where subject_type = 'team'
      and created_at between '#{Date.today.days_ago(3)}' and '#{Date.today}'
      order by score desc
      limit 10;
      SQL
      result = ActiveRecord::Base.connection.execute(query)

      result.to_a
    end

    def group_team_recs
      hash_by_record = last_team_recs
        .group_by{|el| el[:team_id]}
        .values
        .map{ |a,b| b.nil? ? [Hash[*a.first], {'uploads_ids' => [a['upload_id']]}] :
          [Hash[*a.first], {'uploads_ids' => [a['upload_id'],b['upload_id']]}] }
      Hash[*hash_by_record.flatten]
    end

   #-------- data presets for recs

    def basic_dataset_from_infos_to_teams(tid)
      query = <<-SQL
      select uploads_infos.user_id, uploads_infos.upload_id as item_id
      from uploads_infos, users, teams
      where uploads_infos.user_id = users.id
      and users.team_id = #{tid};
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a.uniq.map{ |h| h.transform_keys(&:to_sym) }
    end

    def target_topic_max_rated(tid)
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

    #-------- use recs columns to get composite values

    def implicit_helper_values_top_list
      query = <<-SQL
      select uploads.id as item_id,
      uploads_infos.rating*uploads.downloads_count/disco_recommendations.score as importance
      from uploads, uploads_infos, disco_recommendations
      where ( uploads.rating > 1 and uploads.downloads_count > 2 )
      and uploads_infos.upload_id = uploads.id
      and disco_recommendations.item_id = uploads.id
      and disco_recommendations.item_type = 'upload'
      and disco_recommendations.created_at between '#{Date.today - 1.week}' and '#{Date.today}'
      limit 20;
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end
  end
end
