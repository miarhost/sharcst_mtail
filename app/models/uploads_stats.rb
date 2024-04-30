class UploadsStats < ApplicationRecord
  has_many :uploads
  belongs_to :folder_version
end
