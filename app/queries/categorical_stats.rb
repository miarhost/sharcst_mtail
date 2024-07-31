class CategoricalStats
  def recs_fields_by_category(id)
    query = <<-SQL
        select category_stats.category_id, recommendations_stats.uploads_recs,
        recommendations_stats.infos_ratings, recommendations_stats.user_ids
        from recommendations_stats, category_stats
        where category_stats.category_id = #{id}
    SQL
    recs = ActiveRecord::Base.connection.execute(query).to_a.to_json
  end
end
