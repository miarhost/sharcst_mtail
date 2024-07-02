require 'disco'
module UploadsInfos
  class PredictionRateWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    sidekiq_options queue: :predictions

    def perform(ids)
      records = UploadsInfo.where(id: ids)
      ids = records.map { |r| { 'user_id': r.user_id, 'item_id': r.upload_id } }.uniq
      recommender = Disco::Recommender.new(factors: 20)
      recommender.fit(ids)
      resulting_score = recommender.predict(ids)
      store result: resulting_score
    rescue StandardError => e
      store result:  e.message
    end
  end
end
