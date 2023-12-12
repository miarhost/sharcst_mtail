set :output, "#{path}/log/cron.log"

every :day , at: '9:30 pm' do
  runner 'PopulateUidsWorker.perform_async'
end

every :day, at: '3:08 pm' do
  rake 'subscriptions:update_ratings'
end

every 4.weeks, at: '9:00 am' do
  rake 'emails:send_monthly_recs'
end

every :day, at: '9:00 pm' do
  runner 'DailyRecsQueue.new.execute'
end
