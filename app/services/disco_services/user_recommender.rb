require 'disco'
class DiscoServices::UserRecommender < ApplicationService
  def self.call(user)
    recommender = Disco::Recommender.new(factors: 2)
    data = DataSets::ImplicitFeedback.items_by_download
    recommender.fit(data)
    user_recommendations = recommender.user_recs(user.id)
    recommendations = recommender.predict(data)
    user.update_recommended_uploads(user_recommendations)
    { "result": recommendations, "status": user_recommendations }
  rescue StandardError => e
    {"result": e }
  end
end
