# frozen_string_literal: true

require 'work_api/model/event'
require 'work_api/requests/events/create_event_request'

RSpec.describe(WorkApi::Requests::Events::CreateEventRequest) do
  include_context 'with live client'

  let(:integration_id) { '5e87444cc30f5a0009f0905b' }

  let(:name) { 'Exciting' }
  let(:description) { 'An exciting event' }
  let(:location) { 'An exciting place' }
  let(:start_date_time) { '2020-02-29T00:00:00+01:00' }
  let(:start_timezone) { 'Europe/Budapest' }
  let(:end_date_time) { '2020-02-29T02:00:00+01:00' }
  let(:end_timezone) { 'Europe/Budapest' }
  let(:calendar_id) do
    'NWU4NzQ0NGNjMzBmNWEwMDA5ZjA5MDViOkFRTWtBR0UxT0dSak9HVXhMVEpsTmpNdE5EQXpNaTA1WVRabExXWTROamt6T1RnNU1'\
    'EWTFNUUF1QUFBRE9iVHo2WnR1M0V1VDF0a25rQkFqYkFFQXhpTnJjM3JjbWtfSl9BaUlQMjItTkFBQUFnRU5BQUFB'
  end

  let(:event) do
    WorkApi::Event.new(
      integration_id: integration_id,
      name: name,
      description: description,
      location: location,
      start_date_time: start_date_time,
      start_timezone: start_timezone,
      end_date_time: end_date_time,
      end_timezone: end_timezone,
      calendar_id: calendar_id
    )
  end

  let(:request) { described_class.new(body: event) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('event/events') }
  end

  context 'client#call' do
    let(:cassette_name) { 'event_create_success' }

    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(WorkApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to be_a(WorkApi::Event) }
      it do
        is_expected.to have_attributes(
          name: name,
          location: location,
          calendar_id: calendar_id
        )
      end

      context 'description' do
        subject { call.body.description }
        it { is_expected.to match(/#{description}/) }
      end

      context 'start time' do
        let(:received_time) do
          Time.parse("#{call.body.start_date_time} #{call.body.start_timezone}")
        end
        subject { received_time }
        it { is_expected.to eq(Time.parse(start_date_time)) }
      end

      context 'end time' do
        let(:received_time) do
          Time.parse("#{call.body.end_date_time} #{call.body.end_timezone}")
        end
        subject { received_time }
        it { is_expected.to eq(Time.parse(end_date_time)) }
      end
    end
  end
end
