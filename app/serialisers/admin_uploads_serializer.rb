class AdminUploadsSerializer < ActiveModel::Serializer
  attributes :name
  delegate :cache_key, to: :object
end
