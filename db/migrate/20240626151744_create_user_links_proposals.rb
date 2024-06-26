class CreateUserLinksProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :user_links_proposals do |t|
      t.json :links
      t.references :user, null: false, foreign_key: true
      t.string :origin
      t.boolean :parsed

      t.timestamps
    end
  end
end
