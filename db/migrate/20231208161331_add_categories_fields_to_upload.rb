class AddCategoriesFieldsToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :rating, :integer, default: 0
    add_column :uploads, :category, :string, default: "", null: false
    add_column :uploads, :topic, :string, default: ""
  end
end
