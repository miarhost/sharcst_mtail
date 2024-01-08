class Category < ApplicationRecord
  has_many :topics, dependent: :nullify
end
