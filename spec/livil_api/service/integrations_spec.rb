# frozen_string_literal: true

RSpec.describe(LivilApi::Service::Integrations) do
  include_context 'with service'

  let(:integration_id) { '5e5d1077390585003fd8fc68' }

  context 'list_integrations' do
    let(:api_method) { :list_integrations }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Integration) }
    end
  end

  context 'create_integration' do
    let(:provider) { 'gcal' }
    let(:media_type) { 'event' }
    let(:api_method) { :create_integration }
    let(:integration) { LivilApi::Integration.new(provider: provider, media_type: media_type) }
    let(:args) { { integration: integration } }

    it { is_expected.to be_a(LivilApi::Integration) }
  end

  context 'auth_integration' do
    let(:return_to) { 'http://localhost:3000' }
    let(:api_method) { :auth_integration }
    let(:args) { { integration_id: integration_id, return_to: return_to } }

    it { is_expected.to be_redirect }

    context '#redirect_uri' do
      subject { call.redirect_uri }
      it { is_expected.to match(/^https/) }
    end
  end

  context 'modify_integration' do
    let(:media_type) { 'event' }
    let(:integration) { LivilApi::Integration.new(id: integration_id, media_type: media_type) }
    let(:api_method) { :modify_integration }
    let(:args) { { integration: integration } }

    it { is_expected.to be_a(LivilApi::Integration) }
  end

  context 'destroy_integration' do
    let(:integration_id) { '5e5d2007390585003fd8fc69' }
    let(:api_method) { :destroy_integration }
    let(:args) { { integration_id: integration_id } }

    subject { call.raw_response.status }

    it { is_expected.to eq(204) }
  end
end
