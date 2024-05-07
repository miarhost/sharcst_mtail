class CreateUploadsStats < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads_stats do |t|
      t.integer :upload_id
      t.integer :folder_version_id
      t.json :infos_ratings
      t.date :datetime

      t.timestamps
    end
  end
end
