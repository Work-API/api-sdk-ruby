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

    context 'with recurrence ID' do
      let(:cassette_name) { 'event_list_success_recurrence' }

      let(:recurring_event_id) { Base64.urlsafe_encode64('5e5d1077390585003fd8fc68:43f8hefi5gv88g17k33bm0b6o5') }
      let(:request) { described_class.new(recurring_event_id: recurring_event_id) }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 250) }
      end
    end
  end
end
