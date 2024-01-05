class AddFieldsToUploadsInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads_infos, :rating, :integer, default: 0
    add_column :uploads_infos, :upl_count, :integer, default: 0
    add_column :uploads_infos, :down_count, :integer, default: 0
    add_column :uploads_infos, :log_tag, :string
    add_column :uploads_infos, :date, :datetime
    add_column :uploads_infos, :created_at, :datetime
    add_column :uploads_infos, :updated_at, :datetime
  end
end
