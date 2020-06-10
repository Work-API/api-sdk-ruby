# frozen_string_literal: true

require 'work_api/model/integration'
require 'work_api/requests/integrations/list_integrations_request'

RSpec.describe(WorkApi::Requests::Integrations::ListIntegrationsRequest) do
  include_context 'with token'
  include_context 'with live client'

  let(:request) { described_class.new }

  context 'client#call' do
    subject { response }
    let(:response) { make_request(request) }

    context 'with no integrations found' do
      let(:cassette_name) { 'integration_list_empty' }

      it { is_expected.not_to be_error }
      it { is_expected.to be_success }
      it { is_expected.to be_a(WorkApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with integrations found' do
      let(:cassette_name) { 'integration_list_found' }

      it { is_expected.to be_a(WorkApi::Client::Response) }
      it { is_expected.not_to be_error }
      it { is_expected.to be_success }

      context '#body' do
        subject { response.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }

        context '#first' do
          subject { response.body.first }
          it { is_expected.to have_attributes(provider: 'gcal', media_type: 'event') }
        end
      end
    end
  end
end
