# frozen_string_literal: true

require 'tempfile'
require 'livil_api/model/email'
require 'livil_api/requests/emails/update_draft_request'

RSpec.describe(LivilApi::Requests::Emails::UpdateDraftRequest) do
  include_context 'with live client'

  let(:email_id) { 'NWU3NDY5NmI4NTljMjAwMDA5MDJiMTU5OnItMzY4MTk5NzYwMTMwMjc3MDcyOTo6' }

  let(:email_subject) { 'Test Email Subject Updated (Request)' }
  let(:body) { LivilApi::EmailBody.new(plain_text: ['This is a plain text body segment (updated)']) }
  let(:to_recipients) { [LivilApi::EmailAddress.new(name: 'Dan', address: 'dan+updatedrequest@livil.co')] }

  let(:email_attributes) do
    {
      id: email_id,
      subject: email_subject,
      body: body,
      to_recipients: to_recipients
    }
  end

  let(:email) { LivilApi::Email.new(**email_attributes) }

  let(:request) { described_class.new(body: email, email_id: email_id) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq("email/drafts/#{email_id}") }
  end

  context 'client#call' do
    let(:cassette_name) { 'draft_update_success' }

    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(LivilApi::Client::Response) }

    let(:boundary) { '--test-boundary' }

    before do
      allow(email.serializer)
        .to receive(:boundary)
        .and_return(boundary)
    end

    context '#body' do
      subject { call.body }
      it { is_expected.to be_a(LivilApi::Email) }
    end

    context 'with attachments' do
      let(:email_id) { 'NWU3NDY5NmI4NTljMjAwMDA5MDJiMTU5OnItNjYwMDM5NTM0NTM3NjM4MjI3NDo6' }
      let(:email_attributes) do
        {
          id: email_id,
          subject: email_subject,
          body: body,
          to_recipients: to_recipients,
          attachments: attachments
        }
      end

      context 'direct upload' do
        let(:cassette_name) { 'draft_update_attachment_success' }

        let(:attachments) do
          tempfile_one = Tempfile.new.tap do |tf|
            tf.write('test content one')
            tf.rewind
          end

          attachment_one = LivilApi::EmailAttachment.new
          attachment_one.attach('test_1.txt', tempfile_one)

          tempfile_two = Tempfile.new.tap do |tf|
            tf.write('test content two')
            tf.rewind
          end

          attachment_two = LivilApi::EmailAttachment.new
          attachment_two.attach('test_2.txt', tempfile_two)

          [
            attachment_one,
            attachment_two
          ]
        end

        it { is_expected.to be_success }
      end

      xcontext 'with remote file', 'pending implementation of file integrations' do
        let(:cassette_name) { 'draft_update_attachment_remote_file_success' }

        let(:attachments) do
          attachment_one = LivilApi::EmailAttachment.new
          attachment_one.attach('test_1.txt', tempfile_one)

          tempfile_two = Tempfile.new.tap do |tf|
            tf.write('test content two')
            tf.rewind
          end

          attachment_two = LivilApi::EmailAttachment.new
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
