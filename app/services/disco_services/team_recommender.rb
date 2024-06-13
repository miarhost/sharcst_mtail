require 'disco'
class DiscoServices::TeamRecommender
  class << self
    def call(tid)
      recommender = Disco::Recommender.new
      recommender.fit(data(tid))
      topical_proposals(tid).each do |hash|
        recommender.item_recs(hash["id"].to_i).each do |rec|
          Disco::Recommendation.create!(
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
      DataSets::UploadsInfos
        .basic_dataset_from_infos_to_teams(tid)
    end

    def topical_proposals(tid)
      DataSets::RatingBased
      .target_topic_max_rated_by_team(tid)
    end
  end
end
