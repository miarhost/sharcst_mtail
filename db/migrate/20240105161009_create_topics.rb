class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.string :tag
      t.references :category, null: false, foreign_key: true
    end
  end
end
