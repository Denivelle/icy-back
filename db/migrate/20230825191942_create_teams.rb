# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true, unique: true
      t.string :token, null: false, index: true, unique: true
      t.string :name
      t.string :bot_id

      t.timestamps
    end
  end
end
