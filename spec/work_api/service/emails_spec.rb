# frozen_string_literal: true

RSpec.describe(WorkApi::Service::Emails) do
  include_context 'with service'

  let(:integration_id) { '5e60f76b99ce66000936897b' }

  context 'list_mailboxes' do
    let(:api_method) { :list_mailboxes }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(WorkApi::Mailbox) }
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

    let(:email) { WorkApi::Email.new(**email_attributes) }

    it { is_expected.to eq(:accepted) }
  end

  context 'list_emails' do
    let(:api_method) { :list_emails }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(WorkApi::Email) }
    end

    context 'with params' do
      context 'mailbox_ids' do
        let(:expected_outcome) { 'mailbox_ids_success' }
        let(:mailbox_ids) { ['NWU3NDY5NmI4NTljMjAwMDA5MDJiMTU5OlVOUkVBRDo6'] }

        let(:args) { { mailbox_ids: mailbox_ids } }

        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 20) }
        it 'should have filtered to the mailbox ID' do
          subject.all? { |email| email.mailboxes.map(&:id).include?(mailbox_ids.first) }
        end
      end

      context 'date range' do
        let(:expected_outcome) { 'date_range_success' }
        let(:date_from) { '2019-10-01T00:00z' }
        let(:date_until) { '2019-12-31T00:00z' }

        let(:args) { { date_from: date_from, date_until: date_until } }

        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 20) }
        it 'should have filtered to the date range' do
          subject.all? { |email| (date_from..date_until).include?(email.received_at) }
        end
      end
    end
  end

  context 'get_email' do
    let(:api_method) { :get_email }
    let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }
    let(:args) { { email_id: email_id } }

    it { is_expected.to be_a(WorkApi::Email) }

    context 'with bad ID' do
      let(:expected_outcome) { 'error' }
      let(:email_id) { 'does-not-exist' }

      it 'should raise an error' do
        expect { subject }.to raise_error(WorkApi::RemoteError, /not_found_error/)
      end
    end
  end

  context 'trash_emails' do
    let(:api_method) { :trash_emails }
    let(:email_id) { 'NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MGFhZjY3NDVkZWEwZGM6' }
    let(:args) { { ids: [email_id] } }

    it { is_expected.to eq(:no_content) }
  end

  context 'create_draft' do
    let(:api_method) { :create_draft }
    let(:args) { { email: email } }
    let(:integration_id) { '5e74696b859c20000902b159' }

    let(:email_attributes) do
      {
        integration_id: integration_id,
        subject: 'this is a test',
        to_recipients: [{ address: 'dan@livil.co' }],
        body: { plain_text: ['This is a plain text test email'] }
      }
    end

    let(:email) { WorkApi::Email.new(**email_attributes) }

    it { is_expected.to be_a(WorkApi::Email) }
    it do
      is_expected.to have_attributes(
        **email_attributes,
        body: WorkApi::EmailBody,
        to_recipients: [WorkApi::EmailAddress]
      )
    end
  end

  context 'update_draft' do
    let(:api_method) { :update_draft }
    let(:args) { { email: email, email_id: email_id } }

    let(:email_id) { 'NWU3NDY5NmI4NTljMjAwMDA5MDJiMTU5OnI4ODk5NjcwMDIzNTYxMzU3NzQy' }

    let(:email_attributes) do
      {
        id: email_id,
        subject: 'this is an updated test',
        to_recipients: [{ address: 'dan+updated@livil.co' }],
        body: { plain_text: ['This is an updated plain text test email'] }
      }
    end

    let(:email) { WorkApi::Email.new(**email_attributes) }

    it { is_expected.to be_a(WorkApi::Email) }
    it do
      is_expected.to have_attributes(
        **email_attributes,
        body: WorkApi::EmailBody,
        to_recipients: [WorkApi::EmailAddress]
      )
    end
  end
end
