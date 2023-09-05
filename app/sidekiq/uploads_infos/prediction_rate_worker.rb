require 'disco'
module UploadsInfos
  class PredictionRateWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker

    sidekiq_options queue: :default

    def perform(id)
      records = UploadsInfo.where(upload_id: id)
      ids = records.map { |r| { user_id: r.user_id, item_id: id } }.uniq
      recommender = Disco::Recommender.new(factors: 20)
      recommender.fit(ids)
      resulting_score = recommender.predict(ids)
      store result: resulting_score.join(', ')
    rescue StandardError => e
      store result:  e.message
    end
  end
end
