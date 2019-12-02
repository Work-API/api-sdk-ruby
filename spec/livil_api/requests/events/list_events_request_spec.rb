# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/client'
require 'livil_api/requests/events/list_events_request'

RSpec.describe(LivilApi::Requests::Events::ListEventsRequest) do
  include_context 'with token'

  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('event/events') }
  end

  context 'client#call' do
    context 'with no events found' do
      subject do
        VCR.use_cassette('list_events_empty') do
          client.call(request, token: token)
        end
      end

      it { is_expected.to be_a(LivilApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with events found' do
      let(:call) do
        VCR.use_cassette('list_events_found') do
          client.call(request, token: token)
        end
      end

      subject { call }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }
      end
    end

    context 'with date range' do
      let(:date_from) { '2019-12-02T00:00' }
      let(:date_until) { '2019-12-10T00:00' }
      let(:request) { described_class.new(date_from: date_from, date_until: date_until) }

      let(:call) do
        VCR.use_cassette('list_events_ranged') do
          client.call(request, token: token)
        end
      end

      subject { call }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 1) }
      end
    end
  end
end
