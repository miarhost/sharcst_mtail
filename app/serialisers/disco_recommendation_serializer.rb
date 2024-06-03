class DiscoRecommendationSerializer < ActiveModel::Serializer
  attributes :subject_type, :subject_id, :item_type, :item_id, :score, :created_at
end
