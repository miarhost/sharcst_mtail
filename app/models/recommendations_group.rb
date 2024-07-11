  class RecommendationsGroup < ApplicationRecord
    delegated_type :statable, types: %w[ CategoryStat TopicStat ]
  end
