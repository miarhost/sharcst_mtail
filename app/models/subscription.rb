class Subscription < ApplicationRecord
  has_many :newsletters
  validates_presence_of :title

  scope :without_infos_ratings, -> { where(uploads_ratings: nil) }
end
