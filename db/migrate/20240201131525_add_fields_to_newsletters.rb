class AddFieldsToNewsletters < ActiveRecord::Migration[6.0]
  def change
    add_column :newsletters, :ad_type, :integer, default: 0
    add_column :newsletters, :tag, :string
    add_column :newsletters, :created_at, :datetime
    add_column :newsletters, :updated_at, :datetime
  end
end
