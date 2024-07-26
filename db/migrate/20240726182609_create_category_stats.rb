class CreateCategoryStats < ActiveRecord::Migration[7.0]
  def change
    create_table :category_stats do |t|
      t.string :related_topics, array: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
