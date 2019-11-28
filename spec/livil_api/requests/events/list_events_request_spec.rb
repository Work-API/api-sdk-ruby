# frozen_string_literal: true

require 'livil_api/client'
require 'livil_api/requests/events/list_events_request'

RSpec.describe(LivilApi::Requests::Events::ListEventsRequest) do
  let(:client) { LivilApi::Client.new }
  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('event/events') }
  end

  context 'client#call' do
    subject do
      VCR.use_cassette('list_events') do
        client.call(request)
      end
    end

    it { is_expected.to be_a(LivilApi::Response) }
  end
end
