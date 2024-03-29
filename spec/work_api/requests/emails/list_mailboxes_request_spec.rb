# frozen_string_literal: true

require 'work_api/model/mailbox'
require 'work_api/requests/emails/list_mailboxes_request'

RSpec.describe(WorkApi::Requests::Emails::ListMailboxesRequest) do
  include_context 'with live client'

  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('email/mailboxes') }
  end

  context 'client#call' do
    let(:cassette_name) { 'mailbox_list_success_found' }
    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(WorkApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to be_a(Array) }
      it { is_expected.to have_attributes(count: 16) }
    end
  end
end
