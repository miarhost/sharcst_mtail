class Newsletters::MonthlyUploadsAdminsNewsletter < ApplicationService
  def call
    header = ''
    Upload.where(updated_at: Date.today.prev_month..Date.today.end_of_day)
          .each { |u| header << "#{u.name}: #{u.updated_at}, "}

    Newsletter.create!(
      header: 'Monthly Infos Stats for Admins',
      body: "Uploads for #{Time.now}: #{header}",
      subscription_id: 18
    )
  end
end
