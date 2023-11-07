class DownloadAttachmentSerializer < ActiveModel::Serializer
  attributes :filename, :download_link

  def download_link
    Rails.application.routes.url_helpers.rails_blob_path(object.file, disposition: 'attachment', only_path: true)
  end
end
