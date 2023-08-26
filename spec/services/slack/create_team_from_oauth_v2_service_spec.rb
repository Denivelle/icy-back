# frozen_string_literal: true

describe Slack::CreateTeamFromOauthV2Service do
  subject(:service) { described_class.new(slack_client:).call(code:) }

  before do
    allow(Team).to receive(:create!).and_return(true)
  end

  let(:code) { 'salut' }
  let(:slack_client) { instance_double('Slack::Web::Client', oauth_v2_access: oauth2_response) }

  let(:oauth2_response) do
    {
      'team' => {
        'name' => 'david',
        'id' => '1234'
      },
      'access_token' => 'NIOEHBIOF',
      'bot_user_id' => 'pio'
    }
  end

  it 'create a team with good attributes' do
    expect(service).to be_success

    expect(Team).to have_received(:create!).with(token: oauth2_response['access_token'],
                                                 name: oauth2_response.dig('team', 'name'),
                                                 id: oauth2_response.dig('team', 'id'),
                                                 bot_id: oauth2_response['bot_user_id'])
  end

  context 'when code is invalid' do
    let(:slack_client) do
      instance_double('Slack::Web::Client',
                      oauth_v2_access: ->(*) { raise(Slack::Web::Api::Errors::SlackError, 'invalid_code') })
    end

    it 'do not create a team' do
      expect(service).to be_failure
      expect(Team).not_to have_received(:create!)
    end
  end

  context 'when team is invalid' do
    before do
      allow(Team).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
    end

    it 'return a failure' do
      expect(service).to be_failure
    end
  end
end
