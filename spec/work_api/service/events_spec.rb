# frozen_string_literal: true

RSpec.describe(WorkApi::Service::Events) do
  include_context 'with service'

  let(:integration_id) { '5e7b7829f40c9b001c2d4e6f' }

  context 'list_calendars' do
    let(:api_method) { :list_calendars }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(WorkApi::Calendar) }
    end
  end

  context 'list_events' do
    let(:api_method) { :list_events }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(WorkApi::Event) }
    end
  end

  context 'get_event' do
    let(:api_method) { :get_event }
    let(:event_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOmRmcHY0MjJoNWcyMGM0bXJnMmNob2UxY2Zv' }
    let(:args) { { event_id: event_id } }

    it { is_expected.to be_a(WorkApi::Event) }
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

    let(:event) { WorkApi::Event.new(attributes) }
    let(:args) { { event: event } }

    it { is_expected.to be_a(WorkApi::Event) }
    it { is_expected.to have_attributes(attributes) }
  end

  context 'modify_event' do
    let(:api_method) { :modify_event }
    let(:event_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOmJrYWxsbW1sYWhhZWtzcHZ0aWFsMHF0bnY4' }
    let(:attributes) do
      {
        name: 'new name',
        start_date_time: '2020-02-13T13:00:00+01:00',
        start_timezone: 'Europe/Paris',
        end_date_time: '2020-02-14T14:00:00+01:00',
        end_timezone: 'Europe/Paris'
      }
    end
    let(:event) { WorkApi::Event.new(**attributes) }
    let(:args) { { event_id: event_id, event: event } }

    it { is_expected.to be_a(WorkApi::Event) }
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
      service.create_event(event: WorkApi::Event.new(**attributes))
    end

    let(:api_method) { :destroy_event }
    let(:event_id) { created_event.id }
    let(:args) { { event_id: event_id } }

    it { is_expected.to eq(:no_content) }
  end
end
