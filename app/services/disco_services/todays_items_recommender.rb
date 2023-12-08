require 'disco'
class DiscoServices::TodaysItemsRecommender < ApplicationService
  def initialize(user, records)
    @user, @records = user, records
    @result = {}
  end

  def call
    recommender = Disco::Recommender.new
    users = User.similar_subscriptions(@user.subscription_ids).pluck(:id)
    uploads = Upload.where(category: @records.pluck(:category))
    uploads_ratings_set = [uploads.pluck(:id), uploads.pluck(:rating)].transpose
    data = []
    iteration = 0
    uploads_ratings_set.each do |pair|
      if iteration < users.length
        data << { user_id: users[iteration], item_id: pair[0], rating: pair[1] }
        iteration += 1
      else
        data << { user_id: Upload.find_by(id: pair[0]).user_id, item_id: pair[0], rating: pair[1] }
      end
    end

    recommender.fit(data)
    @records.each do |r|
      @result = recommender.similar_items(r.id, count: 2)
    end
    @result
  end
end
