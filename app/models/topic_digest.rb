class TopicDigest < ApplicationRecord
  belongs_to :topic
  after_create :notify_single_users

  def notify_single_users
   Email::WeeklyTopicLinks.call(topic_id)
  end
end
