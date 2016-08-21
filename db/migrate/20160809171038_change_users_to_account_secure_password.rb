# frozen_string_literal: true
class ChangeUsersToAccountSecurePassword < ActiveRecord::Migration[5.0]
  def up
    rename_column :users, :password_hash, :password_digest
  end

  def down
    rename_column :users, :password_digest, :password_hash
  end
end
