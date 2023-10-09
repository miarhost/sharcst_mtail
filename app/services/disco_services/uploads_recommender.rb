module DiscoServices
  class UploadsRecommender < ApplicationService
    def self.call(ids)
      result = UploadsInfos::PredictionRateWorker.perform_in(1.seconds, ids)
      sleep 6
      Sidekiq::Status.get(result, :result)
    end
  end
end
