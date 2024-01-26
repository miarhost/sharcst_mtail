class CreateTopicDigest < ActiveRecord::Migration[6.0]
  def change
    create_table :topic_digests do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :list_of_5
      t.json :full_list
      t.timestamps
    end
  end
end
