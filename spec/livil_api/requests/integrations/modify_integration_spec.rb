# frozen_string_literal: true

require 'livil_api/model/integration'
require 'livil_api/requests/integrations/modify_integration_request'

RSpec.describe(LivilApi::Requests::Integrations::ModifyIntegrationRequest) do
  include_context 'with live client'

  let(:integration_id) { 'doesnt_exist' }
  let(:integration_update) { LivilApi::Integration.new(provider: provider, media_type: media_type) }

  let(:provider) { 'gmail' }
  let(:media_type) { 'email' }
  let(:request) { described_class.new(integration_id: integration_id, body: integration_update) }

  context 'when does not exist' do
    let(:cassette_name) { 'integration_modify_error' }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq("integrations/#{integration_id}") }
    end

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

  context 'when exists' do
    include_context 'with live integration'

    let(:cassette_name) { 'integration_modify_success' }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq("integrations/#{integration_id}") }
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
end
