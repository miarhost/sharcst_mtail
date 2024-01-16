require 'disco'
class DiscoServices::TeamRecommender
  class << self
    def call(tid)
      recommender = Disco::Recommender.new
      recommender.fit(data(tid))
      topical_proposals(tid).each do |hash|
        recommender.item_recs(hash["id"].to_i).each do |rec|
          DiscoRecommendation.create!(
            item_id: rec[:item_id],
            score: rec[:score],
            subject_id: tid,
            subject_type: 'team',
            item_type: 'upload'
          )
        end
      end
    end

    def data(tid)
      DiscoRecommendationsQueries
        .basic_dataset_from_infos_to_teams(tid)
    end

    def topical_proposals(tid)
      DiscoRecommendationsQueries
        .target_topic_max_rated(tid)
    end
  end
end
