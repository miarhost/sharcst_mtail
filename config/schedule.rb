set :output, "#{path}/log/cron.log"

every :day , at: '20:40 pm' do
  runner 'PopulateUidsWorker.perform_async'
  command "puts 'See uids logs update'"
end

every :day, at: '15:00 pm' do
  rake 'subscriptions:update_ratings'
  command "puts 'DB ratings update'"
end
