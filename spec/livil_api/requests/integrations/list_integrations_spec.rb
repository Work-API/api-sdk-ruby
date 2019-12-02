# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/client'
require 'livil_api/requests/integrations/list_integrations_request'

RSpec.describe(LivilApi::Requests::Integrations::ListIntegrationsRequest) do
  include_context 'with token'

  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('integrations') }
  end

  context 'client#call' do
    context 'with no integrations found' do
      subject do
        VCR.use_cassette('list_integrations_empty') do
          client.call(request, token: token)
        end
      end

      it { is_expected.to be_a(LivilApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with integrations found' do
      let(:call) do
        VCR.use_cassette('list_integrations_found') do
          client.call(request, token: token)
        end
      end

      subject { call }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }

        context '#first' do
          subject { call.body.first }
          it { is_expected.to have_attributes(provider: 'gcal', media_type: 'event') }
        end
      end
    end
  end
end
