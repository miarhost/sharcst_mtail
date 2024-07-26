  class RecommendationsStat < ApplicationRecord
    delegated_type :statable, types: %w[ CategoryStat TopicStat ], primary_key: :id, foreign_key: :statable_id
  end
