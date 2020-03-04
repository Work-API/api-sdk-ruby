# frozen_string_literal: true

require 'livil_api/model/calendar'
require 'livil_api/requests/events/list_calendars_request'

RSpec.describe(LivilApi::Requests::Events::ListCalendarsRequest) do
  include_context 'with live client'

  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('event/calendars') }
  end

  context 'client#call' do
    let(:call) { make_request(request) }
    subject { call }

    context 'with no calendars found' do
      let(:cassette_name) { 'calendar_list_success_empty' }

      it { is_expected.to be_a(LivilApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with calendars found' do
      let(:cassette_name) { 'calendar_list_success_found' }

      it { is_expected.to be_a(LivilApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 3) }
      end
    end
  end
end
