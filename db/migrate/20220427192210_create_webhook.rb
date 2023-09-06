class CreateWebhook < ActiveRecord::Migration[6.0]
  def change
    create_table :webhooks do |t|
      t.integer :upload_id
      t.integer :user_id, null: false
      t.string :url
      t.integer :state, default: 0, null: false
      t.string :secret, limit: 50, null: false
      t.text :description
      t.index ['user_id'], name: 'index_webhooks_on_user_id'
    end
  end
end
