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
FactoryBot.define do
  factory :team_user do
    id { "T#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
    token { "xoxp-#{Faker::Alphanumeric.alphanumeric(number: 52)}}" }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    team_id { "T#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
  end
end
