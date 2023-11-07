class PublicDownloadsSerializer < ActiveModel::Serializer
  attributes :name, :status, :downloads_count
  has_one :upload_attachment, serializer: DownloadAttachmentSerializer
end
