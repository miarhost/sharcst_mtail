class TopicDigest < ApplicationRecord
  belongs_to :topic
  after_create :create_newsletters

  def create_newsletters
   Newsletters::WeeklyTopicLinks.call(topic_id)
  end
end
