class AddFieldsToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_reference :subscriptions, :topic, foreign_key: true, index: true
    add_column :subscriptions, :subs_rate, :integer, default: 0
    add_column :subscriptions, :subs_rating, :integer, default: 0
    add_column :subscriptions, :subs_ratings_infos, :json
  end
end
