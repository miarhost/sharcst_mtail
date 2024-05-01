module DataSets
  class ImplicitFeedback
    class << self
      def items_by_download
        query = <<-SQL
        select user_id, id as item_id
        from uploads
        where uploads.downloads_count > 2
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result.to_a
      end
    end
  end
end
