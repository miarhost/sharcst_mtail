namespace :emails do
desc 'send monthly email with recommendations for user'
task send_monthly_recs: :environment do
  RecordsForPeriod(User, Date.today.prev_month, Date.today).user_active_for_month.each do |user|
    recommendations = DiscoServices::MonthlySubscriberRecommender.call(user)
    MonthlyRecsMailer.recommend_per_user(user, recommendations)
  end
end
