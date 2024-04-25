  class FolderVersion
    has_many :uploads
    belongs_to :user
    has_recommended :uploads_infos
  end
