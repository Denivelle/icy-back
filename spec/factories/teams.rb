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
FactoryBot.define do
  factory :team do
    id { "T#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
    token { "xoxb-#{Faker::Alphanumeric.alphanumeric(number: 52)}}" }
    name { Faker::Company.name }
    bot_id { "B#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
  end
end
