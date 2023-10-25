require 'disco'
class DiscoServices::UserRecommender < ApplicationService
  def self.call(user_id)
    recommender = Disco::Recommender.new
    supscription_recommendations = recommender.user_recs(user_id)
    user.update_recommended(supscription_recommendations)
    { "result": subscription_recommendations }
  rescue StandardError => e
    {"result": e }
  end
end
