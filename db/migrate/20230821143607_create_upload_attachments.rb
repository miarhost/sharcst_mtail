class CreateUploadAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :upload_attachments do |t|
      t.references :upload, foreign_key: true

      t.timestamps null: false
    end
  end
end
