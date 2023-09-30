class AddSubscriptionsFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :subscription_ids, :string, array: true
    add_column :users, :phone_number, :string
  end
end
