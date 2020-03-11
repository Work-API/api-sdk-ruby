# frozen_string_literal: true

RSpec.describe(LivilApi::Service::Events) do
  include_context 'with service'

  let(:integration_id) { '5e5d1077390585003fd8fc68' }

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
end
