class DailyRecsQueue
    def initialize(date)
      @date = RedisData::CollectDailyRecs.call(date)
    end

  def exchange_name
    'snickers'
  end

  def queue_name
    'daily_recs'
  end

  def execute
    BasicPublisher.direct_exchange(exchange_name, queue_name, @date.to_json)
    Rails.logger.info "Daily recs sent to consumer at #{Time.now}"
  rescue StandardError => e
    Rails.logger.error(e.message)
  end
end
