class RemoveFieldsFromUploadsInfos < ActiveRecord::Migration[6.0]
  def change
    remove_column :uploads_infos, :number_of_seeds, :integer, default: 0
    remove_column :uploads_infos, :protocol, :string
  end
end
