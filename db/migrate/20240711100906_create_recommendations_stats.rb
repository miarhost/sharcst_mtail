class CreateRecommendationsStats < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations_stats do |t|
      t.json :uploads_recs
      t.json :infos_ratings
      t.integer :subscription_ids, default: [], array: true
      t.integer :user_ids, default: [], array: true
      t.datetime :date
      t.references :statable, polymorphic: true

      t.timestamps
    end
  end
end
