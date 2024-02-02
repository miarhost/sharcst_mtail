class Newsletter < ApplicationRecord
  belongs_to :subscription

  after_create :notify_single_users

  def notify_single_users
      Mailers::ExternalRecsJob.mail_queue(id) if ad_type == 1
  end
end
