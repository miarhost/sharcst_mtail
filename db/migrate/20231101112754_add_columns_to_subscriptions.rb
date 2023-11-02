class AddColumnsToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :uploads_ratings, :jsonb
    add_column :subscriptions, :newsletters_ratings, :jsonb
    add_column :subscriptions, :updated_at, :datetime
    add_column :subscriptions, :created_at, :datetime
  end
end
