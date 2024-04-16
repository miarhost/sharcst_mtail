namespace :redis_cache do
  desc 'Remove tokens with expired ttl'
  task remove_unused_tokens: :environment do
    redis = Redis.new(url: ENV['REDIS_DEV_CACHE_URL'])
    counter = 0
    redis.scan_each(match: 'ey*') do |key|
      ttl = redis.hmget(key, 'ttl')
     if Time.now.to_i > ttl[0].to_i
      puts "Deleting: #{key}"
      counter += 1
      redis.del(key)
     end
    end
    puts "Tokens deleted #{counter}"
  end
end
