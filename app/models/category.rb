class Category < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :teams, dependent: :nullify
end
