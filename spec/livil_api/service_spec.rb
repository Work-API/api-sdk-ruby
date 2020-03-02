# frozen_string_literal: true

RSpec.describe(LivilApi::Service) do
  include_context 'with token'

  let(:service) { described_class.new(token) }
  let(:expected_outcome) { 'success' }
  let(:cassette_name) { "client_#{api_method.to_s.split('_').reverse.join('_')}_#{expected_outcome}" }
  let(:args) { {} }
  let(:call) do
    VCR.use_cassette(cassette_name) do
      if args.present?
        service.send(api_method, **args)
      else
        service.send(api_method)
      end
    end
  end

  subject { call }

  let(:integration_id) { '5e5d239b3905850018d8fc6a' }

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
    let(:args) { { provider: provider, media_type: media_type } }

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
    let(:api_method) { :modify_integration }
    let(:args) { { integration_id: integration_id, media_type: media_type } }

    it { is_expected.to be_a(LivilApi::Integration) }
  end

  context 'destroy_integration' do
    let(:integration_id) { '5e5d2007390585003fd8fc69' }
    let(:api_method) { :destroy_integration }
    let(:args) { { integration_id: integration_id } }

    subject { call.raw_response.status }

    it { is_expected.to eq(204) }
  end

  context 'list_events' do
    let(:api_method) { :list_events }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Event) }
    end
  end
end
