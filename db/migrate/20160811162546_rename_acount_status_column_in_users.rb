# frozen_string_literal: true
class RenameAcountStatusColumnInUsers < ActiveRecord::Migration[5.0]
  def up
    rename_column :users, :acount_status, :activation
  end

  def down
    rename_column :users, :activation, :acount_status
  end
end
