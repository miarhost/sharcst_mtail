class UploadsInfo < ApplicationRecord
  include UploadsInfoDecorator
  belongs_to :user
  belongs_to :upload
  has_many :uploads_info_attacments, dependent: :destroy
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
end
