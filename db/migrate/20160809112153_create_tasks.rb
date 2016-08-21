# frozen_string_literal: true
class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.belongs_to :user, index: true
      t.string :state

      t.timestamps null: false
    end
  end
end
