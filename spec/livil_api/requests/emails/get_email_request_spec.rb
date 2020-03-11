# frozen_string_literal: true

require 'livil_api/model/email'
require 'livil_api/requests/emails/get_email_request'

RSpec.describe(LivilApi::Requests::Emails::GetEmailRequest) do
  include_context 'with live client'

  let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }

  let(:request) { described_class.new(email_id: email_id) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("email/emails/#{email_id}") }
  end

  context 'client#call' do
    let(:cassette_name) { 'email_get_success' }

    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to be_a(LivilApi::Email) }
    end
  end
end
