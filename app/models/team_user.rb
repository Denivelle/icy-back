# frozen_string_literal: true

# == Schema Information
#
# Table name: team_users
#
#  id         :string           not null, primary key
#  token      :string           not null
#  team_id    :string           not null
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_team_users_on_id       (id)
#  index_team_users_on_team_id  (team_id)
#  index_team_users_on_token    (token)
#
class TeamUser < ApplicationRecord
  self.primary_key = :id

  validates :id, :token, presence: true, uniqueness: true

  belongs_to :team, inverse_of: :team_users
end
