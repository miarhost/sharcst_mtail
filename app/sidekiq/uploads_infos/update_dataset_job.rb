module UploadsInfos
  class UpdateDatasetJob
    include Sidekiq::Worker
    include Sidekiq::Status::Worker
    sidekiq_options queue: :queries

    def perform(user_id, upl_id, fv_id, *args)
      data = DataSets::MajorInfos.call(*args, fv_id, upl_id)
    end

    def self.bulk_update(user_id, upl_id, fv_id)
      records = UploadsInfo.where.not(user_id: user_id, upload_id: upl_id)
                           .where('down_count > 2 and media_type IN (0,1,2)')
      records.find_in_batches do |items_group|
        perform_async(items_group.ids)
      end
    end
  end
end
