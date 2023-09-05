class UploadAttachment < ApplicationRecord
  belongs_to :upload
  has_one_attached :file
  delegate_missing_to :file
  validates :file, blob: { content_type: %r{^image/}, size_range: 1..100.megabytes }
end
