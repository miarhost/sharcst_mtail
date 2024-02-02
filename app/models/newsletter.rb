class Newsletter < ApplicationRecord
  belongs_to :subscription

  after_create :mail_ext_recs_users, if: -> { ad_type == 1 }
  after_create :message_ext_recs_users, if: -> { ad_type == 1 }

  def mail_ext_recs_users
      Mailers::ExternalRecsMailJob.bulk_mail(id)
  end

  def message_ext_recs_users
    Messengers::ExternalRecsMessageJob.perform_async(id)
  end
end
