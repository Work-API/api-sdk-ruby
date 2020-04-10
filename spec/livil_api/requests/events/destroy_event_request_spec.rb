# frozen_string_literal: true

require 'livil_api/model/event'
require 'livil_api/requests/events/destroy_event_request'

RSpec.describe(LivilApi::Requests::Events::DestroyEventRequest) do
  include_context 'with live client'
  let(:service) { LivilApi::Service.new(token) }

  let(:event_attributes) do
    {
      integration_id: '5e7b7829f40c9b001c2d4e6f',
      name: 'should be deleted',
      start_date_time: '2020-02-13T13:00:00+01:00',
      start_timezone: 'Europe/Paris',
      end_date_time: '2020-02-14T14:00:00+01:00',
      end_timezone: 'Europe/Paris'
    }
  end

  let(:created_event) do
    VCR.use_cassette(cassette_name) do
      service.create_event(event: LivilApi::Event.new(**event_attributes))
    end
  end
  let(:event_id) { created_event.id }

  let(:cassette_name) { 'event_destroy_success' }

  let(:request) { described_class.new(event_id: event_id) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("event/events/#{event_id}") }
  end

  context 'client#call' do
    subject { response }
    let(:response) { make_request(request) }

    it { is_expected.not_to be_error }
    it { is_expected.to be_success }

    context '#body' do
      subject { response.body }
      it { is_expected.to eq(:no_content) }
    end
  end
end
