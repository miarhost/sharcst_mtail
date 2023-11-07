class AddFieldsToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :downloads_count, :integer, default: 0
    add_column :uploads, :status, :string, default: 'public'
  end
end
