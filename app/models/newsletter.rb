class Newsletter < ApplicationRecord
  belongs_to :subscription

  after_create :notify_single_users

  def notify_single_users
      Mailers::ExternalRecsJob.perform_async(id) if type == 1
  end
end
