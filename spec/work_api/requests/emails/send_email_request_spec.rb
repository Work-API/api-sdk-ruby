# frozen_string_literal: true

require 'tempfile'
require 'work_api/model/email'
require 'work_api/requests/emails/send_email_request'

RSpec.describe(WorkApi::Requests::Emails::SendEmailRequest) do
  include_context 'with live client'

  let(:integration_id) { '5e60f76b99ce66000936897b' }

  let(:email_subject) { 'Test Email Subject' }
  let(:body) { WorkApi::EmailBody.new(plain_text: ['This is a plain text body segment']) }
  let(:to_recipients) { [WorkApi::EmailAddress.new(name: 'Dan', address: 'dan@livil.co')] }

  let(:email_attributes) do
    {
      integration_id: integration_id,
      subject: email_subject,
      body: body,
      to_recipients: to_recipients
    }
  end

  let(:email) { WorkApi::Email.new(**email_attributes) }

  let(:request) { described_class.new(body: email) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('email/emails') }
  end

  context 'client#call' do
    let(:cassette_name) { 'email_send_success' }

    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(WorkApi::Client::Response) }

    let(:boundary) { '--test-boundary' }

    before do
      allow(email.serializer)
        .to receive(:boundary)
        .and_return(boundary)
    end

    context '#body' do
      subject { call.body }
      it { is_expected.to eq(:accepted) }
    end

    context 'with attachments' do
      let(:email_attributes) do
        {
          integration_id: integration_id,
          subject: email_subject,
          body: body,
          to_recipients: to_recipients,
          attachments: attachments
        }
      end

      context 'direct upload' do
        let(:cassette_name) { 'email_send_attachment_success' }

        let(:attachments) do
          tempfile_one = Tempfile.new.tap do |tf|
            tf.write('test content one')
            tf.rewind
          end

          attachment_one = WorkApi::EmailAttachment.new
          attachment_one.attach('test_1.txt', tempfile_one)

          tempfile_two = Tempfile.new.tap do |tf|
            tf.write('test content two')
            tf.rewind
          end

          attachment_two = WorkApi::EmailAttachment.new
          attachment_two.attach('test_2.txt', tempfile_two)

          [
            attachment_one,
            attachment_two
          ]
        end

        it { is_expected.to be_success }
      end

      xcontext 'with remote file', 'pending implementation of file integrations' do
        let(:cassette_name) { 'email_send_attachment_remote_file_success' }

        let(:attachments) do
          attachment_one = WorkApi::EmailAttachment.new
          attachment_one.attach('test_1.txt', tempfile_one)

          tempfile_two = Tempfile.new.tap do |tf|
            tf.write('test content two')
            tf.rewind
          end

          attachment_two = WorkApi::EmailAttachment.new
          attachment_two.attach('test_2.txt', tempfile_two)

          [
            attachment_one,
            attachment_two
          ]
        end

        it { is_expected.to be_success }
      end
    end
  end
end
