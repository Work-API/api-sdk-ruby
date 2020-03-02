# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/requests/integrations/auth_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::AuthIntegrationRequest) do
  include_context 'with live client'
  include_context 'with live integration'

  let(:return_to) { 'http://localhost:3000/done' }
  let(:redirect) { true }
  let(:request) { described_class.new(integration_id: integration_id, redirect: redirect, return_to: return_to) }

  # Note: created with the same environment prior to adding provider_configs.
  # To recreate, you need a blank environment
  context 'with empty environment' do
    let(:cassette_name) { 'auth_integration_empty_environment' }

    context 'client#call' do
      let(:response) { make_request(request) }

      context '#body' do
        subject { response.body }
        it { is_expected.to eq(:no_content) }
      end

      context '@error?' do
        subject { response }
        it { is_expected.to be_error }
      end
    end
  end

  context 'with populated environment' do
    let(:cassette_name) { 'auth_integration_success' }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq("auth/init/#{integration_id}") }
    end

    context 'client#call' do
      let(:call) { make_request(request) }

      subject { call }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to include(:uri) }
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
        it { is_expected.to include('token' => String) }
      end
    end
  end
end
