require 'disco'
class DiscoServices::TeamRecommender < ApplicationService
  attr_reader :tid
  def initialize(tid)
    @tid = tid
  end

  def call
    return no_training_data if data.empty?
    recommender = Disco::Recommender.new
    recommender.fit(data)
    topical_proposals.each do |hash|
      recommender.item_recs(hash["id"].to_i).each do |rec|
        Disco::Recommendation.create!(
          item_id: rec[:item_id],
          score: rec[:score],
          subject_id: tid,
          subject_type: 'Team',
          item_type: 'Upload'
        )
      end
    end
  end

  def data
    DataSets::UploadsInfos
      .basic_dataset_from_infos_to_teams(tid)
  end

  def topical_proposals
    DataSets::RatingBased
    .target_topic_max_rated_by_team(tid)
  end
end
