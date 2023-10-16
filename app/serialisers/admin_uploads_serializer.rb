class AdminUploadsSerializer < ActiveModel::Serializer
  attributes: :name
  cached
  delegate :cache_key, to: :object
end
