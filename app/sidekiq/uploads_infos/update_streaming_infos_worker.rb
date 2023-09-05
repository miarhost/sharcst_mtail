module UploadsInfos
  class UpdateStreamingInfosWorker
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :default

    def perform(record_id)
      record = UploadsInfo.find(record_id)
      updated_template = { logging_url: record.user.webhook.url }

      if record.streaming_infos.nil?
        record.update!(streaming_infos: updated_template)
      else
        record.update!(streaming_infos: record.streaming_infos.merge(updated_template))
      end
    rescue StandardError => e
      store result: record.errors.blank? ? nil : e.message
    end
  end
end
