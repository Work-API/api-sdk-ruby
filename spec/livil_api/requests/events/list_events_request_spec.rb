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
        it { is_expected.to have_attributes(count: 1) }
      end
    end

    context 'with date range' do
      let(:cassette_name) { 'event_list_success_ranged' }

      let(:date_from) { '2019-12-02T00:00' }
      let(:date_until) { '2019-12-10T00:00' }
      let(:request) { described_class.new(date_from: date_from, date_until: date_until) }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }
      end
    end
  end
end
