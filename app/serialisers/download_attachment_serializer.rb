class DownloadAttachmentSerializer < ActiveModel::Serializer
  attributes :filename, :download_link

  def download_link
    if object.attached?
    Rails.application.routes.url_helpers.rails_blob_path(object.file, disposition: 'attachment', only_path: true)
    else
      'Sorry, seems like file is absent or removed by owner.'
    end
  end

  def filename
    object.attached? ? object.filename : 'Sorry, seems like file is absent or removed by owner.'
  end
end
