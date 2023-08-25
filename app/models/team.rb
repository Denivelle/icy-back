# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id         :string           not null, primary key
#  token      :string           not null
#  name       :string
#  bot_id     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_id     (id)
#  index_teams_on_token  (token)
#
class Team < ApplicationRecord
  self.primary_key = :id
end
