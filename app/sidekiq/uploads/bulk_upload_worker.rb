module Uploads
  class BulkUploadWorker
    include Sidekiq::Job
    sidekiq_options queue: :upload
    def perform(bulk_filenames)
      Uploads::UploadJob.perform_bulk('args': [bulk_filenames], batch: 300)
    end
  end
end
