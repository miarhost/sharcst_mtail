class AddFieldsToUserLinksProposals < ActiveRecord::Migration[7.0]
  def change
    add_column :user_links_proposals, :topics, :string, array: true
    add_column :user_links_proposals, :rate, :integer
    change_column :user_links_proposals, :parsed, :boolean, default: false
  end
end
