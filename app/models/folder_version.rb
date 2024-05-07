  class FolderVersion < ApplicationRecord
    belongs_to :user
    has_many :uploads_stats
    has_many :uploads, through: :uploads_stats
    has_recommended :uploads_infos
  end
