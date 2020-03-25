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

  context 'send_email' do
    let(:api_method) { :send_email }
    let(:args) { { email: email } }

    let(:email_attributes) do
      {
        integration_id: integration_id,
        subject: 'this is a test',
        to_recipients: [{ address: 'dan@livil.co' }],
        body: { plain_text: ['This is a plain text test email'] }
      }
    end

    let(:email) { LivilApi::Email.new(**email_attributes) }

    it { is_expected.to eq(:accepted) }
  end

  context 'list_emails' do
    let(:api_method) { :list_emails }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Email) }
    end
  end

  context 'get_email' do
    let(:api_method) { :get_email }
    let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }
    let(:args) { { email_id: email_id } }

    it { is_expected.to be_a(LivilApi::Email) }

    context 'with bad ID' do
      let(:expected_outcome) { 'error' }
      let(:email_id) { 'does-not-exist' }

      it 'should raise an error' do
        expect { subject }.to raise_error(LivilApi::RemoteError, /not_found_error/)
      end
    end
  end

  context 'trash_emails' do
    let(:api_method) { :trash_emails }
    let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }
    let(:args) { { ids: [email_id] } }

    it { is_expected.to eq(:no_content) }
  end
end
