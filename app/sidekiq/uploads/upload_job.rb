module Uploads
  class UploadJob
  include Sidekiq::Worker
    sidekiq_options queue: :upload

    def perform(fpath, uid)
      upload = Upload.create!(user_id: uid, name: fpath)
      attachment = upload.build_upload_attachment
      file = File.open(fpath)
      attachment.attach(
        io: file,
        filename: file.basename,
        content_type: file.content_type
      )
      attachment.save!
      FileUtils.rm(file)
    end
  end
end
