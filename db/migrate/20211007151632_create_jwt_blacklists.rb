class CreateJwtBlacklists < ActiveRecord::Migration[6.0]
  def change
    create_table :jwt_black_lists do |t|
      t.string :jti,              null: false, default: ''
      t.datetime :exp, null: true
      t.timestamps null: false
    end
  end
end
