# frozen_string_literal: true

RSpec.describe(LivilApi::Service) do
  include_context 'with token'

  let(:service) { described_class.new(token) }
  subject { call }

  context 'create_integration' do
    let(:provider) { 'gcal' }
    let(:media_type) { 'event' }

    let(:call) do
      VCR.use_cassette('create_integration_success') do
        service.create_integration(provider: provider, media_type: media_type)
      end
    end

    it { is_expected.to be_a(LivilApi::Integration) }
  end

  context 'auth_integration' do
    let(:integration_id) { '5ddfde529f0a31000804bb94' }
    let(:return_to) { 'http://localhost:3000' }

    let(:call) do
      VCR.use_cassette('auth_integration_success') do
        service.auth_integration(
          integration_id: integration_id,
          return_to: return_to
        )
      end
    end

    it { is_expected.to be_redirect }

    context '#redirect_uri' do
      subject { call.redirect_uri }
      it { is_expected.to match(/^https/) }
    end
  end

  context 'destroy_integration' do
    let(:integration_id) { '5ddfde529f0a31000804bb94' }

    let(:call) do
      VCR.use_cassette('destroy_integration') do
        service.destroy_integration(integration_id: integration_id)
      end
    end

    subject { call.raw_response.status }

    it { is_expected.to eq(204) }
  end
end
