# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/client'
require 'livil_api/requests/integrations/auth_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::AuthIntegrationRequest) do
  include_context 'with token'

  let(:integration_id) { '5ddfde529f0a31000804bb94' }
  let(:return_to) { 'http://localhost:3000/done' }
  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new(integration_id: integration_id, redirect: false, return_to: return_to) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("auth/init/#{integration_id}") }
  end

  context 'client#call' do
    let(:call) do
      VCR.use_cassette('auth_integration') do
        client.call(request, token: token)
      end
    end

    subject { call }

    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to eq(:no_content) }
    end

    context '#redirect_uri' do
      let(:redirect_uri) { call.redirect_uri }
      let(:parsed_uri) { URI.parse(call.redirect_uri) }
      let(:query_params) { CGI.parse(parsed_uri.query) }
      let(:state_param) { query_params['state'].first }
      let(:decoded_state_param) { JSON.parse(Base64.decode64(Base64.decode64(state_param))) }

      subject { decoded_state_param }

      it { is_expected.to include('return_to' => return_to) }
      it { is_expected.to include('integration_id' => integration_id) }
      it { is_expected.to include('token' => token) }
    end
  end
end
