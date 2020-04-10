# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/requests/events/get_event_request'

RSpec.describe(LivilApi::Requests::Events::GetEventRequest) do
  include_context 'with live client'

  let(:event_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOmRmcHY0MjJoNWcyMGM0bXJnMmNob2UxY2Zv' }
  let(:params) { { event_id: event_id } }
  let(:request) { described_class.new(**params) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("event/events/#{event_id}") }
  end

  context 'client#call' do
    let(:call) { make_request(request) }
    subject { call }

    context 'without calendar_id' do
      let(:cassette_name) { 'event_get_success' }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(LivilApi::Event) }
      end
    end

    context 'with calendar_id' do
      let(:cassette_name) { 'event_get_with_calendar_id_success' }
      let(:event_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOmRmcHY0MjJoNWcyMGM0bXJnMmNob2UxY2Zv' }
      let(:calendar_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOnByaW1hcnk6' }
      let(:params) { { event_id: event_id, calendar_id: calendar_id } }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(LivilApi::Event) }
        it { is_expected.to have_attributes(calendar_id: calendar_id) }
      end
    end
  end
end
