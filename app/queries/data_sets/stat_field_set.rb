module DataSets
  class StatFieldSet
    def initialize(record_id, rec_group_id=nil)
      @user_ids = rec_group_id ? RecommendationGroup.find(rec_group_id).user_ids : user_ids
      @record_id = record_id
      @rec_group_id ||= rec_group_id
    end

    def collect_upload_recs
      recs = Disco::Recommendation.select(:item_id)
                                  .where(item_type: "Upload", subject_id: user_ids)
                                  .pluck(:subject_id, :item_id)
      recs.map { |a| { user: a[0], upload: a[1] } }.to_json
    end

    def by_info; end

    def by_subscription; end

    def user_ids
      if @rec_group_id
        RecommendationGroup.find(rec_group_id).user_ids
      else
        topics = @record.topics.ids || @record.id
        User.joins(:uploads).where('uploads.topic_id in (?)', topic_ids).pluck(:ids).uniq
      end
    end
  end
end
