class Category < ApplicationRecord
  has_many :topics, dependent: :nullify
  has_many :category_stats, dependent: :destroy
end
