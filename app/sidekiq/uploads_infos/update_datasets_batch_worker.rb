module UploadsInfos
  class UpdateDatasetsBatchWorker
    include Sidekiq::Job
    include Sidekiq::Status::Worker
    sidekiq_options queue: :predictions

    def perform(user_id, upl_id, fv_id)
      bulk_results = []
      records = UploadsInfo.where.not(user_id: user_id, upload_id: upl_id)
                           .where('down_count > 2 and media_type IN (0,1,2)')
      records.find_in_batches do |items_group|
        extracted_job = UploadsInfos::UpdateDatasetJob.perform_bulk([items_group.pluck(:id), [user_id, upl_id, fv_id]])
        bulk_results << { result: Sidekiq::Status.get(extracted_job, :result)}
      end
      store bulk_results: bulk_results.to_json
    rescue StandardError => e
      store bulk_results: e.message
    end
  end

  class UpdateDatasetJob
    include Sidekiq::Job
    include Sidekiq::Status::Worker
    sidekiq_options queue: :predictions

    def perform(*args, upl_id, fv_id)
      data = DataSets::MajorInfos.call(*args, fv_id, upl_id)
      store result: data
    rescue StandardError => e
      store result: e.message
    end
  end
end
