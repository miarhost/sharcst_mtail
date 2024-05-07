class AddVersionToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :version, :integer, default: 0
  end
end
