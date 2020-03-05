# frozen_string_literal: true

RSpec.describe(LivilApi::Service::Emails) do
  include_context 'with service'

  let(:integration_id) { '5e60f76b99ce66000936897b' }

  context 'list_mailboxes' do
    let(:api_method) { :list_mailboxes }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Mailbox) }
    end
  end

  context 'list_emails' do
    let(:api_method) { :list_emails }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Email) }
    end
  end
end
