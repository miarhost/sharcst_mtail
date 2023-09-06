class CreateUploadsInfoAttacments < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads_info_attacments do |t|
      t.references :uploads_info, null: false, foreign_key: true
    end
  end
end
