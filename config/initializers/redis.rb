ConnectionPool::Wrapper.new {
Redis.new(host: ENV["REDIS_URL"])
}
