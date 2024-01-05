class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :tag
      t.integer :category_id
      t.integer :topic_id
      t.index ['category_id'], name: 'index_teams_on_category_id'
    end
  end
end
