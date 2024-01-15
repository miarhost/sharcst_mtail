class ImportanceListDeliverQueue
  class << self
    def exchange_name
      'snickers'
    end

    def queue_name
      'importances'
    end

    def execute(payload)
      BasicPublisher.direct_exchange(exchange_name, queue_name, payload)
      Rails.logger.info "Importances payload sent to consumer at #{Time.now}"
    rescue StandardError => e
      Rails.logger.error(e.full_messages.to_sentence)
    end
  end
end
