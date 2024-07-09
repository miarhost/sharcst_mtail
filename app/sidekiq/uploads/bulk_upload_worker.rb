module Uploads
  class BulkUploadWorker
    include Sidekiq::Job
    sidekiq_options queue: :upload

    def perform(bulk_filenames, uid)
      Uploads::UploadJob.perform_bulk([[bulk_filenames, uid]], batch_size: 10)
    end
  end
end
