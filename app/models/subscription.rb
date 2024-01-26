class Subscription < ApplicationRecord
  has_many :newsletters
  validates_presence_of :title
  belongs_to :topic

  scope :without_uploads_ratings, -> { where(uploads_ratings: nil) }
end
