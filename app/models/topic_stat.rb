class TopicStat < ApplicationRecord
  include Statable
  belongs_to :topic
end
