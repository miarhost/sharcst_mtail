class AddNameToUploads < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :name, :string
    add_column :uploads, :date, :datetime
  end
end
