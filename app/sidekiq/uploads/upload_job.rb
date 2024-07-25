module Uploads
  class UploadJob
  include Sidekiq::Worker
    sidekiq_options queue: :upload

    def perform(fpath, uid)
      upload = Upload.create!(user_id: uid, name: fpath)
      attachment = upload.build_upload_attachment
      File.open(fpath, "a") do |file|
        attachment.attach(
          io: file,
          filename: file.basename,
          content_type: file.content_type
        )
      attachment.save!
      end
    end
  end
end
