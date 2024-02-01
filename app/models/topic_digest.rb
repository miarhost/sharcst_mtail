class TopicDigest < ApplicationRecord
  belongs_to :topic
  after_create :create_newsletters

  def create_newsletters
   Email::WeeklyTopicLinks.call(topic_id)
  end
end
