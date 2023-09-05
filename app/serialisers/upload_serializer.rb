class UploadSerializer < ActiveModel::Serializer
  attributes :user_id, :name

  has_one :upload_attachment, serializer: UploadAttachmentSerializer
end
