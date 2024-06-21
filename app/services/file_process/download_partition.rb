module FileProcess
  class DownloadPartition < ApplicationService
    def self.call(attachment_id)
      Uploads::DownloadsWorker.perform_async(attachment_id, chunk_size)
    end
  end
end
