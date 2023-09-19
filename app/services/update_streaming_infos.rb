class UpdateStreamingInfos < ApplicationService
  def self.call(record_id)
    result = UploadsInfos::UpdateStreamingInfosWorker.perform_in(1.seconds, record_id)
    sleep 6
    output = Sidekiq::Status.get(result, :result)
    output.nil? ? UploadsInfo.find(record_id) : { 'message' => output }
  end
end
