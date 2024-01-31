class ChangeSubsIdsTypeToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :subscription_ids, :integer, using: "subscription_ids::integer[]", array: true, default: []
  end
end
