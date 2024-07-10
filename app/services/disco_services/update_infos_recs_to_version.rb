require 'disco'
module DiscoServices
  class UpdateInfosRecsToVersion < ApplicationService

    def initialize(upl_id)
      @upload = Upload.find(upl_id)
    end

    def call
      recommender = Disco::Recommender.new(factors: 4)

      recommender.fit(data)
      recs = recommender.item_recs(@upload.id)
      @upload.update_recommended_uploads_infos(recs)
      @upload.recommended_uploads_infos
    end

    def data
      records = UploadsStat.where(upload_id: @upload.id)
      records.pluck(:infos_ratings)
             .map{|r| JSON.parse(r) }
             .flatten
             .map(&:symbolize_keys)
    end
  end
end
