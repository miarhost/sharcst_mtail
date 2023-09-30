class CreateNewsletter < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletters do |t|
      t.references :subscription, null: false, foreign_key: true
      t.string :header
      t.string :name
      t.text :body
      t.datetime :date
      t.integer :uploads_info_id

      t.index :date, name: "index_newsletters_by_dates", unique: true
    end
  end
end
