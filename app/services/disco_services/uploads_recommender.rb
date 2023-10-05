module DiscoServices
  class UploadsRecommender < ApplicationService
    def self.call(id)
      records = UploadsInfo.where(upload_id: id)
      ids = records.map { |r| { user_id: r.user_id, item_id: id } }.uniq
      result = UploadsInfos::PredictionRateWorker.perform_in(1.seconds, ids)
      sleep 6
      Sidekiq::Status.get(result, :result)
    end
  end
end
