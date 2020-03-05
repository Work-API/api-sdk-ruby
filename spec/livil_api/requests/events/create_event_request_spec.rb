# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/requests/events/create_event_request'

RSpec.describe(LivilApi::Requests::Events::CreateEventRequest) do
  include_context 'with live client'

  # TODO: add support for adding event on specific calendar
  # let(:calendar_remote_id) { 'primary' }
  # let(:calendar_id) { Base64.urlsafe_encode64("#{integration_id}:#{calendar_remote_id}") }

  let(:integration_id) { '5e5d1077390585003fd8fc68' }

  let(:name) { 'Exciting' }
  let(:description) { 'An exciting event' }
  let(:location) { 'An exciting place' }
  let(:start_date_time) { '2020-02-29T00:00:00+01:00' }
  let(:start_timezone) { 'Europe/Budapest' }
  let(:end_date_time) { '2020-02-29T02:00:00+01:00' }
  let(:end_timezone) { 'Europe/Budapest' }

  let(:event) do
    LivilApi::Event.new(
      integration_id: integration_id,
      name: name,
      description: description,
      location: location,
      start_date_time: start_date_time,
      start_timezone: start_timezone,
      end_date_time: end_date_time,
      end_timezone: end_timezone
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

    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to be_a(LivilApi::Event) }
      it do
        is_expected.to have_attributes(
          name: name,
          description: description,
          location: location,
          start_date_time: start_date_time,
          start_timezone: start_timezone,
          end_date_time: end_date_time,
          end_timezone: end_timezone
        )
      end
    end
  end
end
