class CreateUpload < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
