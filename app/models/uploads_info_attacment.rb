class UploadsInfoAttacment < ApplicationRecord
  belongs_to :uploads_info
  has_one_attached :document
  delegate_missing_to :document
  validates :document, blob: { content_type: %r{^application/}, size_range: 1..100.megabytes }
end
