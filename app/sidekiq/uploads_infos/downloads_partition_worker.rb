module UploadsInfos
  class DownloadsPartitionWorker
    include Sidekiq::Worker
    sidekiq_options queue: :upload, retry_queue: :tail, retry: 1, backtrace: 3

    def perform(attachment_id, chunk_size)
      UploadsInfoAttacment.find(attachment_id).blob.open do |temp|
        until temp.eof?
          File.open("tmp/#{temp.pos / chunk_size.to_i}", "w") do |el|
            el << temp.read(chunk_size)
        end rescue StandardError
          :kill
        end
      end
    end
  end
end
