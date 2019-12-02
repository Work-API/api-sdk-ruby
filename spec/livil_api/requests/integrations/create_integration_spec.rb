# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/client'
require 'livil_api/requests/integrations/create_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::CreateIntegrationRequest) do
  include_context 'with token'

  let(:provider) { 'gcal' }
  let(:media_type) { 'event' }
  let(:integration) { LivilApi::Integration.new(provider: provider, media_type: media_type) }
  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new(body: integration) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('integrations') }
  end

  context 'client#call' do
    let(:call) do
      VCR.use_cassette('create_integration_success') do
        client.call(request, token: token)
      end
    end

    subject { call }

    it { is_expected.to be_a(LivilApi::Client::Response) }
    it { is_expected.to have_attributes(body: LivilApi::Integration) }

    context '#body' do
      subject { call.body }
      it { is_expected.to have_attributes(provider: provider, media_type: media_type) }
    end
  end
end
