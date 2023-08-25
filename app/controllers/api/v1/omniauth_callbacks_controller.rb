# frozen_string_literal: true

module Api
  module V1
    class OmniauthCallbacksController < Api::V1::ApiController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def slack
        ::Slack::CreateTeamFromOauthV2Service.call(code: params[:code])

        head :ok
      end
    end
  end
end
