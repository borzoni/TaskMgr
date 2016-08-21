# frozen_string_literal: true
class AddAccountStatusColumnAndDateToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column 'users', 'acount_status', :integer, default: 0
    add_column 'users', 'activated_at', :datetime
  end

  def down
    remove_column 'users', 'acount_status'
    remove_column 'users', 'activated_at'
  end
end
