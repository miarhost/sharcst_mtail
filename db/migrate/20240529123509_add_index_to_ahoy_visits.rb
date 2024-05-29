class AddIndexToAhoyVisits < ActiveRecord::Migration[7.0]
  def change
    add_index :ahoy_visits, :visitor_token
    add_index :ahoy_visits, :started_at
  end
end
