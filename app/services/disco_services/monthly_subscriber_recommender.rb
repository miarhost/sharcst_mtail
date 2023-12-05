require 'disco'
module DiscoServices
  class MonthlySubscriberRecommender < ApplicationService
    def self.call(user)
      datas = []
      recommender = Disco::Recommender.new(factors: 20)
      target_upload_infos = UploadsInfo.left_outer_joins(:upload).where('uploads.date between ? and ?', Date.today.prev_month, Date.today)
      target_upload_infos.each do |info|
        datas << { user_id: info.user_id, item_id: info.upload_id }
      end

      recommender.fit(datas)
      user_recs = recommender.user_recs(user.id)
      recommender_1 = Disco::Recommender.new(factors: 4, top_items: true)
      recommender_1.fit(datas)
      recs_per_user = user_recs == [] ? recommender_1.top_items : user_recs
      user_rating = recommender.predict(datas)
      { recs: recs_per_user, future_rating: user_rating }
    end
  end
end
