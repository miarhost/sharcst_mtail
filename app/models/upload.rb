class Upload < ApplicationRecord
  has_one :upload_attachment, dependent: :destroy
  has_many :uploads_infos, dependent: :destroy
  has_recommended :uploads_infos
  belongs_to :user
  validates_presence_of :name
  after_create { publish_to_dashboard }
  visitable :ahoy_visit

  scope :public_status, -> { where(status: 'public')}
  scope :downloaded, -> { where('downloads_count > 0')}

  private

  def publish_to_dashboard
    BasicPublisher.publish('uploads', attributes)
  end

  def downloads_board
    self.class.joins(:ahoy_visit).group('updated_at').count
  end
end
