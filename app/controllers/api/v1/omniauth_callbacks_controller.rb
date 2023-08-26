# frozen_string_literal: true

module Api
  module V1
    class OmniauthCallbacksController < Api::V1::ApiController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def slack
        code = params[:code]
        ::Slack::CreateTeamFromOauthV2Service.call(code:) if code

        head :ok
      end

      def sign_in_slack
        code = params[:code]
        ::Slack::CreateTeamUserFromOpenIdService.call(code:) if code

        head :ok
      end
    end
  end
end
