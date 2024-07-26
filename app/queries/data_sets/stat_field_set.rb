module DataSets
  class StatFieldSet
    def initialize(record_id, record_name, rec_group_id=nil)
      @record = record_name.constantize.find(record_id)
      @rec_group_id ||= rec_group_id
      @user_ids = @rec_group_id ? RecommendationGroup.find(rec_group_id).user_ids : user_ids
    end
    attr_reader :record_name

    def collect_upload_recs
      recs = Disco::Recommendation.where(item_type: "Upload", subject_id: @user_ids)
                                  .pluck(:subject_id, :item_id)
      recs.map { |a| { user: a[0], upload: a[1] } }.to_json
    end

    def collect_infos_recs
      query = <<-SQL
        select subject_id as upload, item_id as uploads_info, score
        from disco_recommendations
        where item_type = 'UploadsInfo'
        and subject_id in(select uploads.id from uploads, categories
          join topics on topics.category_id = categories.id
          where categories.id = #{@record.id} and uploads.topic_id = topics.id);
      SQL
      ActiveRecord::Base.connection.execute(query).to_a.to_json
    end

    def by_subscription; end

    def topic_ids
      topic_ids = record_name == 'Category' ? @record.topics.ids : [@record.id]
    end

    def user_ids
      User.joins(:uploads).where('uploads.topic_id in (?)', topic_ids).pluck(:id).uniq
    end
  end
end
