class AddTimestampsToUploads < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :created_at, :datetime
    add_column :uploads, :updated_at, :datetime
  end
end
