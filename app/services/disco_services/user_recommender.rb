require 'disco'
class DiscoServices::UserRecommender < ApplicationService
  def self.call(user)
    data = []
    recommender = Disco::Recommender.new(factors: 2)
    user.uploads.each do |u|
     data << { user_id: user.id, item_id: u.id }
    end
    recommender.fit(data)
    user_recommendations = recommender.user_recs(user.id)
    recommendations = recommender.predict(data)
    user.update_recommended_uploads(user_recommendations)
    { "result": recommendations, "status": user_recommendations }
  rescue StandardError => e
    {"result": e }
  end
end
