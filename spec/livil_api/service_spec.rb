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

  context 'list_calendars' do
    let(:api_method) { :list_calendars }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Calendar) }
    end
  end

  context 'list_events' do
    let(:api_method) { :list_events }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Event) }
    end
  end

  context 'create_event' do
    let(:api_method) { :create_event }
    let(:attributes) do
      {
        name: 'test',
        start_date_time: '2020-02-29T13:00:00+01:00',
        start_timezone: 'Europe/Budapest',
        end_date_time: '2020-02-29T14:00:00+01:00',
        end_timezone: 'Europe/Budapest',
        integration_id: integration_id
      }
    end

    let(:event) { LivilApi::Event.new(attributes) }
    let(:args) { { event: event } }

    it { is_expected.to be_a(LivilApi::Event) }
    it { is_expected.to have_attributes(attributes) }
  end

  context 'modify_event' do
    let(:api_method) { :modify_event }
    let(:event_id) { 'NWU1ZDEwNzczOTA1ODUwMDNmZDhmYzY4OmZpcG1kc3ZicGQ5cnVzNGkzamJiazE1NjFv' }
    let(:attributes) do
      {
        name: 'new name',
        start_date_time: '2020-02-13T13:00:00+01:00',
        start_timezone: 'Europe/Paris',
        end_date_time: '2020-02-14T14:00:00+01:00',
        end_timezone: 'Europe/Paris'
      }
    end
    let(:event) { LivilApi::Event.new(**attributes) }
    let(:args) { { event_id: event_id, event: event } }

    it { is_expected.to be_a(LivilApi::Event) }
    it { is_expected.to have_attributes(attributes) }
  end

  context 'destroy_event' do
    let(:attributes) do
      {
        integration_id: integration_id,
        name: 'should be deleted',
        start_date_time: '2020-02-13T13:00:00+01:00',
        start_timezone: 'Europe/Paris',
        end_date_time: '2020-02-14T14:00:00+01:00',
        end_timezone: 'Europe/Paris'
      }
    end

    let(:created_event) do
      service.create_event(event: LivilApi::Event.new(**attributes))
    end

    let(:api_method) { :destroy_event }
    let(:event_id) { created_event.id }
    let(:args) { { event_id: event_id } }

    it { is_expected.to eq(:no_content) }
  end

  context 'list_mailboxes' do
    let(:api_method) { :list_mailboxes }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Mailbox) }
    end
  end
end
