class Team < ApplicationRecord
  has_many :users, dependent: :nullify
  belongs_to :category, optional: true
  belongs_to :topic, optional: true
  validates :tag, length: { minimum: 2, maximum: 55 }
  has_recommended :uploads
end
