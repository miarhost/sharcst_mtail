class Team < ApplicationRecord
  has_many :users, as: :member, class_name: 'User', dependent: :nullify
  belongs_to :category, optional: true
end
