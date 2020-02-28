# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/client'
require 'livil_api/requests/integrations/destroy_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::DestroyIntegrationRequest) do
  include_context 'with live client'
  include_context 'with live integration'

  let(:cassette_name) { 'integration_destroy' }

  let(:request) { described_class.new(integration_id: integration_id) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("integrations/#{integration_id}") }
  end

  context 'client#call' do
    subject { response }
    let(:response) { make_request(request) }

    it { is_expected.not_to be_error }
    it { is_expected.to be_success }

    context '#body' do
      subject { response.body }
      it { is_expected.to eq(:no_content) }
    end
  end
end
