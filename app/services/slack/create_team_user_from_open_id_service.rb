# frozen_string_literal: true

module Slack
  class CreateTeamUserFromOpenIdService < ApplicationService
    SIGN_IN_SLACK_REDIRECT_URI = "#{ENV.fetch('NGROK_URI', nil)}/api/v1/omniauth_callback/sign_in_slack".freeze
    SIGN_IN_SLACK_URI = 'https://slack.com/openid/connect/authorize?response_type=code&client_id=' \
                        "#{ENV.fetch('SLACK_CLIENT_ID', nil)}&scope=openid,profile,email&redirect_uri=" +
                        SIGN_IN_SLACK_REDIRECT_URI.freeze

    def initialize(
      slack_client: Slack::Web::Client.new
    )
      @slack_client = slack_client
    end

    def call(code:)
      access_token = get_openid_access_token(code)
      user_info_response = get_user_info_response(access_token)
      create_team_user!(access_token, user_info_response)

      Success()
    rescue ActiveRecord::RecordInvalid => e
      Failure(e)
    end

    private

    def get_openid_access_token(code)
      openid_connect_token = @slack_client.openid_connect_token(
        {
          client_id: ENV.fetch('SLACK_CLIENT_ID', nil),
          client_secret: ENV.fetch('SLACK_CLIENT_SECRET', nil),
          redirect_uri: SIGN_IN_SLACK_REDIRECT_URI,
          code:
        }
      )
      openid_connect_token['access_token']
    end

    def get_user_info_response(token)
      @slack_client.openid_connect_userInfo(token:)
    end

    def create_team_user!(access_token, user_info_response)
      TeamUser.create!(email: user_info_response['email'],
                       token: access_token,
                       name: user_info_response['name'],
                       team_id: user_info_response['https://slack.com/team_id'],
                       id: user_info_response['https://slack.com/user_id'])
    end
  end
end
