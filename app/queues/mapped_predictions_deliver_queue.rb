class MappedPredictionsDeliverQueue
  def initialize(records, values)
    @records = records
    @values = values
  end

  def queue_name
    'predictions'
  end

  def exchange_name
    'sneakers'
  end

  def data_hash
    Hash[@records.pluck(:name).zip(@values)]
  end

  def execute
    BasicPublisher.direct_exchange(exchange_name, queue_name, data_hash.to_json)
  rescue Interrupt => e
    Rails.logger.error(e.message)
  end
end
