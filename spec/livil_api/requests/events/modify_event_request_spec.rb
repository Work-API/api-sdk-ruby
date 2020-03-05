# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/requests/events/modify_event_request'

RSpec.describe(LivilApi::Requests::Events::ModifyEventRequest) do
  include_context 'with live client'

  # TODO: add support for moving event between calendars
  # let(:calendar_remote_id) { 'primary' }
  # let(:calendar_id) { Base64.urlsafe_encode64("#{integration_id}:#{calendar_remote_id}") }

  let(:event_id) { 'NWU1ZDEwNzczOTA1ODUwMDNmZDhmYzY4OmZpcG1kc3ZicGQ5cnVzNGkzamJiazE1NjFv' }

  let(:name) { 'New name' }
  let(:description) { 'A new description' }
  let(:location) { 'A change of location' }
  let(:start_date_time) { '2020-02-01T00:00:00+00:00' }
  let(:start_timezone) { 'Europe/London' }
  let(:end_date_time) { '2020-02-02T02:00:00+00:00' }
  let(:end_timezone) { 'Europe/London' }

  let(:event) do
    LivilApi::Event.new(
      id: event_id,
      name: name,
      description: description,
      location: location,
      start_date_time: start_date_time,
      start_timezone: start_timezone,
      end_date_time: end_date_time,
      end_timezone: end_timezone
    )
  end

  let(:request) { described_class.new(event_id: event_id, body: event) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("event/events/#{event_id}") }
  end

  context 'client#call' do
    let(:cassette_name) { 'event_modify_success' }

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
