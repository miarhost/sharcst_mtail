class UploadsStat < ApplicationRecord
  has_many :uploads
  belongs_to :folder_version
end
