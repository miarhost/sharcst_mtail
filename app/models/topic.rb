class Topic < ApplicationRecord
  belongs_to :category
  has_many :teams, dependent: :nullify
end
