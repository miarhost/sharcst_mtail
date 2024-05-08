set :output, "#{path}/log/cron.log"

every :day , at: '13:15 pm' do
  runner 'PopulateUidsWorker.perform_async'
end

every :day, at: '18.17 pm' do
  rake 'subscriptions:update_subscriptions_ratings'
end

every :day, at: '19:10 pm' do
  rake 'emails:send_monthly_recs'
end

every :day, at: '16:12 pm' do
  runner 'DailyRecsQueue.new(Date.today).execute'
end

every :day, at: '12:07 pm' do
  rake 'uploads:send_weekly_user_rates'
end

every :day, at: '20.20 pm' do
  runner 'Mailers::TeamRecommenderMailJob.perform_async'
end

every 3.days, at: '01.00 am' do
  rake 'redis_cache:remove_unused_tokens'
end


every 7.days, at: '22.23 pm' do
  runner 'UploadsInfos::UpdateDatasetJob.bulk_update'
end
