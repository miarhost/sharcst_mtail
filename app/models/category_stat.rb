class CategoryStat < ApplicationRecord
  include Statable
  belongs_to :category
end
