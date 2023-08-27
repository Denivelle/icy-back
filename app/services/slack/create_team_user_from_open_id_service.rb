# frozen_string_literal: true

module Slack
  class CreateTeamUserFromOpenIdService < ApplicationService
    SIGN_IN_SLACK_REDIRECT_URI = Rails.application.routes.url_helpers.sign_in_slack_api_v1_omniauth_callback_url.freeze

    SIGN_IN_SLACK_URI = 'https://slack.com/openid/connect/authorize?response_type=code&scope=openid,profile,email&' \
                        "redirect_uri=#{SIGN_IN_SLACK_REDIRECT_URI}&client_id=#{ENV.fetch('SLACK_CLIENT_ID', nil)}"
                        .freeze

    def initialize(
      slack_client: Slack::Web::Client.new
    )
      @slack_client = slack_client
    end

    def call(code:)
      fetch_openid_access_token(code)
      create_team_user!(fetch_openid_user_info)

      Success()
    rescue ActiveRecord::RecordInvalid => e
      Failure(e)
    end

    private

    def fetch_openid_access_token(code)
      openid_connect_token = @slack_client.openid_connect_token(
        {
          client_id: ENV.fetch('SLACK_CLIENT_ID', nil),
          client_secret: ENV.fetch('SLACK_CLIENT_SECRET', nil),
          redirect_uri: SIGN_IN_SLACK_REDIRECT_URI,
          code:
        }
      )
      @access_token = openid_connect_token['access_token']
    end

    def fetch_openid_user_info
      @slack_client.openid_connect_userInfo(token: @access_token)
    end

    def create_team_user!(user_info_response)
      TeamUser.create!(id: user_info_response['https://slack.com/user_id'],
                       team_id: user_info_response['https://slack.com/team_id'],
                       email: user_info_response['email'],
                       name: user_info_response['name'],
                       token: @access_token)
    end
  end
end
