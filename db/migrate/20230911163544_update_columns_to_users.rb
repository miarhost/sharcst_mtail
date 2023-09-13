# frozen_string_literal: true

class UpdateColumnsToUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :encrypted_password, :string, null: false, default: ''
    add_column :users, :password_digest, :string, null: false, default: ''
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_ip, :inet
    add_column :users, :jti, :string, null: false, default: ''
  end

  def down
    add_column :users, :encrypted_password, :string, null: false, default: ''
    remove_column :users, :password_digest, :string, null: false, default: ''
    remove_column :users, :sign_in_count, :integer, default: 0, null: false
    remove_column :users, :current_sign_in_ip, :inet
    remove_column :users, :jti, :string, null: false, default: ''
  end
end
