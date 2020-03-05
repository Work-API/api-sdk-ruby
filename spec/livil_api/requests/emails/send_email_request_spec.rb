# frozen_string_literal: true

require 'livil_api/model/email'
require 'livil_api/requests/emails/send_email_request'

RSpec.describe(LivilApi::Requests::Emails::SendEmailRequest) do
  include_context 'with live client'

  let(:integration_id) { '5e60f76b99ce66000936897b' }

  let(:email_subject) { 'Test Email Subject' }
  let(:body) { LivilApi::EmailBody.new(plain_text: ['This is a plain text body segment']) }
  let(:to_recipients) { [LivilApi::EmailAddress.new(name: 'Dan', address: 'dan@livil.co')] }

  let(:email_attributes) do
    {
      integration_id: integration_id,
      subject: email_subject,
      body: body,
      to_recipients: to_recipients
    }
  end

  let(:email) { LivilApi::Email.new(**email_attributes) }

  let(:request) { described_class.new(body: email) }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('email/emails') }
  end

  context 'client#call' do
    let(:cassette_name) { 'email_send_success' }

    let(:call) { make_request(request) }
    subject { call }

    it { is_expected.to be_a(LivilApi::Client::Response) }

    context '#body' do
      subject { call.body }
      it { is_expected.to eq(:no_content) }
    end
  end
end
