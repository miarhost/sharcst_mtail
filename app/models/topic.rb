class Topic < ApplicationRecord
  belongs_to :category
  has_many :teams, dependent: :nullify
  has_many :topic_digests
end
