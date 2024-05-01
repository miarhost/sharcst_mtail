module DiscoServices
  class UpdateRecommendedInfos < ApplicationService

    def initialize(sid, fid)
      @sid = sid
      @folder_version = FolderVersion.find(fid)
    end

    def data(sid)
      DataSets::RatingBased
        .target_topic_max_rated_by_subscription(@sid)
        .map(&:symbolize_keys)
    end

    def call
      @folder_version.update_recommended_uploads_infos(data)
    end
  end
end
