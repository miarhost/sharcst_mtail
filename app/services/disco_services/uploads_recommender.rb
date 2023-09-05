module DiscoServices
  class UploadsRecommender < ApplicationService
    def self.call(id)
      result = UploadsInfos::PredictionRateWorker.perform_in(1.seconds, id)
      sleep 6
      Sidekiq::Status.get(result, :result)
    end
  end
end
