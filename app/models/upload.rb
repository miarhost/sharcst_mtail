class Upload < ApplicationRecord
  has_one :upload_attachment, dependent: :destroy
  has_many :uploads_infos, dependent: :destroy
  has_recommended :uploads_infos
  belongs_to :user
  validates_presence_of :name, :category
  visitable :ahoy_visit

  scope :public_status, -> { where(status: 'public')}
  scope :downloaded, -> { where('downloads_count > 0')}
  scope :for_period, ->(start_date, end_date) { where('date is not null and date between ? and ?', start_date, end_date)}
  private

  def downloads_board
    self.class.joins(:ahoy_visit).group('updated_at').count
  end
end
