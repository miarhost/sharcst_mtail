class AddColumnsToUploadsInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads_infos, :name, :string, null: false
    add_column :uploads_infos, :description, :text
    add_column :uploads_infos, :duration, :decimal
    add_column :uploads_infos, :provider, :string
  end
end
