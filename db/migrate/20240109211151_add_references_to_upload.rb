class AddReferencesToUpload < ActiveRecord::Migration[6.0]
  def change
    add_reference :uploads, :topic, index: true
  end
end
