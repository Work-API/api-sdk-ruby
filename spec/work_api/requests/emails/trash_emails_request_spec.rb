# frozen_string_literal: true

require 'work_api/model/email'
require 'work_api/requests/emails/trash_emails_request'

RSpec.describe(WorkApi::Requests::Emails::TrashEmailsRequest) do
  include_context 'with live client'
  let(:service) { WorkApi::Service.new(token) }

  let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }

  let(:cassette_name) { 'email_trash_success' }

  let(:request) { described_class.new(ids: [email_id]) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('email/emails') }
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
