class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.integer :role, default: 0

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
