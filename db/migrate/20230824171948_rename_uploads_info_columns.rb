class RenameUploadsInfoColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :uploads_infos, :type, :media_type
  end
end
