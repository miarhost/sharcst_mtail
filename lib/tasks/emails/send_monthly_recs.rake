namespace :emails do
desc 'send monthly email with recommendations for user'
  task send_monthly_recs: :environment do
    RecordsForPeriod.new(User, Date.today.prev_month, Date.today).user_active_for_month.each do |user|
      recommendations = DiscoServices::MonthlySubscriberRecommender.call(user)
      MonthlyRecsMailer.with(user: user, recommendations: recommendations).recommend_per_user.deliver_now
      puts "Delivered for #{user.email}: #{recommendations}"
    end
  rescue => e
    puts e.message
  end
end
