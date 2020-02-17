# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/requests/integrations/create_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::CreateIntegrationRequest) do
  include_context 'with live client'

  let(:cassette_name) { 'integration_create_success' }

  let(:provider) { 'gcal' }
  let(:media_type) { 'event' }

  let(:integration) { LivilApi::Integration.new(provider: provider, media_type: media_type) }

  let(:request) { described_class.new(body: integration) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('integrations') }
  end

  context 'client#call' do
    subject { response }

    let(:response) { make_request(request) }

    it { is_expected.not_to be_error }
    it { is_expected.to be_success }
    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { response.body }
      it { is_expected.to be_a(LivilApi::Integration) }
      it { is_expected.to have_attributes(provider: provider, media_type: media_type) }
    end
  end
end
