# frozen_string_literal: true

require_relative '../support/acceptance_tests_helper'

resource 'Omniauth Callbacks' do
  header 'Content-Type', 'application/json'

  route '/api/v1/omniauth_callback/slack', 'Slack' do
    get 'Get' do
      before do
        allow(ENV).to receive(:fetch).with('SLACK_CLIENT_ID', nil).once.and_return(client_id)
        allow(ENV).to receive(:fetch).with('SLACK_CLIENT_SECRET', nil).and_return(client_secret)
      end

      let(:client_id) { 'my_slack_client_id' }
      let(:client_secret) { 'my_slack_client_secret' }
      let(:code) { 'my_super_code' }
      let(:team_id) { 'team_id' }

      let(:stub_oauth2_response) do
        return_value = Rails.root.join('spec/mocks/slack/oauth.v2.access/success.json').read
        return_value.gsub!('"id": "T9TK3CUKW"', "\"id\": \"#{team_id}\"")
        stub_request(:post, 'https://slack.com/api/oauth.v2.access')
          .with(
            body: { 'client_id' => client_id, 'client_secret' => client_secret, 'code' => code },
            headers: {
              'Accept' => 'application/json; charset=utf-8',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/x-www-form-urlencoded',
              'User-Agent' => 'Slack Ruby Client/2.1.0'
            }
          ).to_return(status: 200, body: return_value, headers: {})
      end

      example 'When the user accept to install the bot it create a team' do
        stub_oauth2_response
        expect {
          do_request({ code: })
        }.to change(Team, :count).by(1)

        expect(status).to eq 200
      end

      example 'When the user refuse to install the bot, it does not create a team' do
        expect {
          do_request({ error: 'access_denied' })
        }.not_to change(Team, :count)

        expect(status).to eq 200
      end

      context 'when the user has already installed the bot' do
        before do
          create(:team, id: team_id)
        end

        example 'It does not create a team' do
          stub_oauth2_response
          expect {
            do_request({ code: })
          }.not_to change(Team, :count)

          expect(status).to eq 200
        end
      end
    end
  end
end
