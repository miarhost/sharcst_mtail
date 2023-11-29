class UploadAttachment < ApplicationRecord
  belongs_to :upload
  has_one_attached :file
  delegate_missing_to :file
  validates :file, blob: { content_type: %r{^image/}, size_range: 2.kilobytes..100.megabytes }
  after_create { sync_dates }

  private
  def sync_dates
    upload.update(date: created_at)
  end
end
