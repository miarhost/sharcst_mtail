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
      subids = "#{User.find(uid).subscription_ids}".delete("[]")
      query = <<-SQL
      select disco_recommendations.score, teams.tag, subscriptions.title
      from disco_recommendations, users, teams, subscriptions
      where disco_recommendations.subject_type = 'user'
      and (disco_recommendations.subject_id = #{uid}
      or subscriptions.id in(#{subids}))
      and users.team_id = teams.id;
      SQL
      result = ActiveRecord::Base.connection.execute(query)
      result.to_a
    end

    def recs_for_category_teams(cid)
      query = <<-SQL
      select disco_recommendations.item_id, users.id as user_id
      from disco_recommendations, teams, users, categories
      where disco_recommendations.subject_id = users.id
      and users.team_id = teams.id
      and teams.category_id = #{cid};
      SQL
      ActiveRecord::Base.connection.execute(query).to_a
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

    def extract_created(type)
      Disco::Recommendation.where(item_type: type, created_at: (Time.now - 1.hour..Time.now))
    end

    #-------- use recs columns to get composite values

    def implicit_helper_values_top_list
      query = <<-SQL
      select uploads.id as item_id, disco_recommendations.item_type,
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
