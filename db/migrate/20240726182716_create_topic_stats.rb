class CreateTopicStats < ActiveRecord::Migration[7.0]
  def change
    create_table :topic_stats do |t|
      t.json :external_recs
      t.string :last_digests, array: true
      t.references :topic, foreign_key: true

      t.timestamps
    end
  end
end
