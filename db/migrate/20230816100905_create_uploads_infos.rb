class CreateUploadsInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :upload, null: false, foreign_key: true
      t.json :streaming_infos
      t.integer :type, default: 0
      t.integer :number_of_seeds, default: 0
      t.string :protocol
    end
  end
end
