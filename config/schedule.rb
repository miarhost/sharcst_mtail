set :output, "#{path}/log/cron.log"

every :day , at: '20:40 pm' do
  runner 'PopulateUidsWorker.perform_async'
  command "puts 'See uids logs update'"
end
