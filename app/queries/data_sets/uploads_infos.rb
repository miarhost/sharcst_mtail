module DataSets
  class UploadsInfos
    class << self

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
    end
  end
end
