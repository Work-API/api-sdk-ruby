# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/client'
require 'livil_api/requests/integrations/destroy_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::DestroyIntegrationRequest) do
  include_context 'with token'

  let(:integration_id) { '5ddfde529f0a31000804bb94' }
  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new(integration_id: integration_id) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("integrations/#{integration_id}") }
  end

  context 'client#call' do
    let(:call) do
      VCR.use_cassette('destroy_integration') do
        client.call(request, token: token)
      end
    end

    subject do
      call
    end

    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to eq(:no_content) }
    end
  end
end
