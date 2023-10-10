module DiscoServices
  class UploadsRecommender < ApplicationService
    def self.call(ids)
      result = UploadsInfos::PredictionRateWorker.perform_async(ids)
      sleep 6
      Sidekiq::Status.get(result, :result)
    end
  end
end
