class Subscription < ApplicationRecord
  has_many :newsletters
  validates_presence_of :title
end
