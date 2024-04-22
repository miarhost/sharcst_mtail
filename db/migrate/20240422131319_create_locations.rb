class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :country
      t.string :city
      t.string :country_code
      t.references :locatable, polymorphic: true
      t.timestamps
    end
  end
end
