# frozen_string_literal: true

module Slack
  class CreateTeamFromOauthV2Service < ApplicationService
    def initialize(
      slack_client: Slack::Web::Client.new
    )
      @slack_client = slack_client
    end

    def call(code:)
      oauth2_response = get_oauth2_response(code)
      create_team!(oauth2_response)

      Success()
    rescue ActiveRecord::RecordInvalid, Slack::Web::Api::Errors::SlackError => e
      Failure(e)
    end

    private

    def get_oauth2_response(code)
      @slack_client.oauth_v2_access(
        {
          client_id: ENV.fetch('SLACK_CLIENT_ID', nil),
          client_secret: ENV.fetch('SLACK_CLIENT_SECRET', nil),
          code:
        }
      )
    end

    def create_team!(oauth2_response)
      team_info = oauth2_response['team']

      Team.create!(token: oauth2_response['access_token'],
                   name: team_info['name'],
                   id: team_info['id'],
                   bot_id: oauth2_response['bot_user_id'])
    end
  end
end
