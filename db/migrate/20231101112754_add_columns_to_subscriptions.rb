class AddColumnsToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :uploads_ratings, :jsonb
    add_column :subscriptions, :newsletters_ratings, :jsonb
  end
end
