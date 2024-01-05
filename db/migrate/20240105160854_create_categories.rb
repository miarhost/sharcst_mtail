class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :tag
      t.string :title, null: false
    end
  end
end
