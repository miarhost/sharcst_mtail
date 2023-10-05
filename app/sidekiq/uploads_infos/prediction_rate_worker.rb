require 'disco'
module UploadsInfos
  class PredictionRateWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    sidekiq_options queue: :default

    def perform(ids)
      recommender = Disco::Recommender.new(factors: 20)
      recommender.fit(ids)
      resulting_score = recommender.predict(ids)
      store result: resulting_score.join(', ')
    rescue StandardError => e
      store result:  e.message
    end
  end
end
