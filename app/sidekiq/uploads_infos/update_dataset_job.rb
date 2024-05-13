module UploadsInfos
  class UpdateDatasetJob
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :queries

    def perform(user_id, upl_id, fv_id, *args)
      data = DataSets::MajorInfos.call(*args, fv_id, upl_id)
      store result: data
    rescue StandardError => e
      store result: e.message
    end

    def bulk_update(user_id, upl_id, fv_id)
      bulk_results = []
      records = UploadsInfo.where.not(user_id: user_id, upload_id: upl_id)
                           .where('down_count > 2 and media_type IN (0,1,2)')
      records.find_in_batches do |items_group|
        extracted_job = perform_async(user_id, upl_id, fv_id, items_group.pluck(:id))
        bulk_results << { jid: extracted_job, result: Sidekiq::Status.get_all(extracted_job, :result)}
      end
      store bulk_results: bulk_results.to_json
    rescue StandardError => e
      store bulk_results: e.message
    end
  end
end
