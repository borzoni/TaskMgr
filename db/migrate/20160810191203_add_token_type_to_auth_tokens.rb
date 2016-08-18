class AddTokenTypeToAuthTokens < ActiveRecord::Migration[5.0]
  def up
    add_column 'auth_tokens', 'token_type', :integer, default: 0
  end

  def down
    remove_column 'auth_tokens', 'token_type'
  end
end
