# frozen_string_literal: true

class CreateTeamUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_users, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true, unique: true
      t.string :token, null: false, index: true, unique: true
      t.string :team_id, null: false, index: true
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
