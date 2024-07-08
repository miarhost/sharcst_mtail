module Uploads
  class UploadJob
  include Sidekiq::Worker
    sidekiq_options queue: :upload

    def perform(fpath, uid)
      upload = Upload.create!(user_id: uid, name: fpath)
      attachment = upload.build_upload_attachment
      file = File.open(fpath, "w")
      attachment.attach(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )
      attachment.save!
    end
  end
end
