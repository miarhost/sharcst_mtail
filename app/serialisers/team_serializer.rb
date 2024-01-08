class TeamSerializer < ActiveModel::Serializer
  attributes :tag
  has_many :users, serializer: MemberSerializer
  belongs_to :category, serializer: CategorySerializer
  belongs_to :topic, serializer: TopicSerializer
end
