module DiscoServices
  class UpdateInfosRecsToVersion < ApplicationService

    def initialize(user_id, upl_id)
      @user_id, @upl_id = user_id, upl_id
    end

    def call
      recommender = Disco::Recommender.new(factors: 4)

      recommender.fit(data)
      recs = recommender.item_recs(upl_id)
      Upload.find(upl_id).update_recommended_uploads_infos(recs)
    end

    def data
      records = UploadsStats.where(upload_id: @upl_id)
      records.pluck(:infos_ratings)
             .map{|r| JSON.parse(r) }
             .flatten
             .map(&:symbolize_keys)
    end
  end
end
