class CreateFolderVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :folder_versions do |t|
      t.references :upload
      t.references :user
      t.string :version
      t.timestamps
    end
  end
end
