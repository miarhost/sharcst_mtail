class PublicUploadsSerializer < ActiveModel::Serializer
  attributes :name
  has_one :upload_attachment, serializer: UploadAttachmentSerializer
end
