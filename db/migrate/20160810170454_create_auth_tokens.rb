class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.integer :authenticatable_id
      t.string :authenticatable_type
      t.string :secret_id
      t.string :hashed_secret
      t.timestamps
    end
    add_index :auth_tokens, :secret_id, unique: true
    add_index :auth_tokens, %i(authenticatable_type authenticatable_id), name: 'authenticatable_id_type_idx'
  end
end
