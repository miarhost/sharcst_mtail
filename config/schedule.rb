set :output, "#{path}/log/cron.log"

every :day , at: '13:30 pm' do
  runner 'PopulateUidsWorker.perform_async'
end

every :day, at: '15.00 pm' do
  rake 'subscriptions:update_subscriptions_ratings'
end

every 4.weeks, at: '20:10 pm' do
  rake 'emails:send_monthly_recs'
end

every :day, at: '21:41 pm' do
  runner 'DailyRecsQueue.new.execute'
end
