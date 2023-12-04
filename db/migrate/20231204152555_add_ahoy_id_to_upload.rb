class AddAhoyIdToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :ahoy_visit_id, :string
  end
end
