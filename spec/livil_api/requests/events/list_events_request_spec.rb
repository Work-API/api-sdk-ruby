# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/requests/events/list_events_request'

RSpec.describe(LivilApi::Requests::Events::ListEventsRequest) do
  include_context 'with live client'

  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('event/events') }
  end

  context 'client#call' do
    let(:call) { make_request(request) }
    subject { call }

    context 'with no events found' do
      let(:cassette_name) { 'event_list_success_empty' }

      it { is_expected.to be_a(LivilApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with events found' do
      let(:cassette_name) { 'event_list_success_found' }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 22) }
      end
    end

    context 'with date range' do
      let(:cassette_name) { 'event_list_success_ranged' }

      let(:date_from) { '2019-11-18T00:00' }
      let(:date_until) { '2019-12-20T00:00' }
      let(:request) { described_class.new(date_from: date_from, date_until: date_until) }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 4) }
      end
    end

    context 'with search_text string' do
      let(:cassette_name) { 'event_list_success_search_text' }

      let(:search_text) { 'batch' }
      let(:request) { described_class.new(search_text: search_text) }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }
      end
    end

    context 'with recurring event ID', focus: true do
      let(:cassette_name) { 'event_list_success_recurrence' }

      let(:calendar_id) { 'NWU3Yjc4MjlmNDBjOWIwMDFjMmQ0ZTZmOnByaW1hcnk6' }
      let(:integration_id) { '5e7b7829f40c9b001c2d4e6f' }
      let(:remote_id) { '06j3o6f51d1q7649sd53gb6v5a' }
      let(:recurring_event_id) { Base64.urlsafe_encode64("#{integration_id}:#{remote_id}") }
      let(:request) { described_class.new(calendar_ids: [calendar_id], recurring_event_id: recurring_event_id) }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 250) }
      end
    end
  end
end
