# frozen_string_literal: true

require 'tempfile'

RSpec.describe(WorkApi::Email) do
  context 'serialization' do
    let(:integration_id) { '5e60f76b99ce66000936897b' }
    let(:email_subject) { 'Email with attachments' }
    let(:body) { WorkApi::EmailBody.new(plain_text: ['This is a plain text body segment']) }
    let(:to_recipients) { [WorkApi::EmailAddress.new(name: 'Dan', address: 'dan@livil.co')] }

    let(:attributes) do
      {
        subject: email_subject,
        body: body,
        to_recipients: to_recipients
      }
    end

    let(:model) { described_class.new(**attributes) }
    let(:serializer) { model.serializer }

    context '#serializer' do
      subject { serializer }
      it { is_expected.to have_attributes(content_type: 'application/vnd.api+json') }
    end

    context '#serialize' do
      subject { serializer.serialize }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to include(:attributes, :type) }

      context '#attributes' do
        subject { serializer.serialize[:attributes] }
        it { is_expected.to be_a(Hash) }
        it do
          is_expected.to include(
            :bcc_recipients,
            :body,
            :cc_recipients,
            :integration_id,
            :sender,
            :subject,
            :to_recipients
          )
        end
      end
    end

    context 'with attachments' do
      let(:attachment) do
        tempfile = Tempfile.new('email-serialization-test').tap do |tf|
          tf.write('test contents')
          tf.rewind
        end

        WorkApi::EmailAttachment.new.tap do |a|
          a.attach('test-file.txt', tempfile)
        end
      end

      let(:attachments) { [attachment] }

      let(:attributes) do
        {
          integration_id: integration_id,
          subject: email_subject,
          body: body,
          to_recipients: to_recipients,
          attachments: attachments
        }
      end

      before do
        allow(serializer)
          .to receive(:boundary)
          .and_return(boundary)
      end

      let(:boundary) { '----test-boundary' }

      context '#serializer' do
        subject { serializer }
        it { is_expected.to have_attributes(content_type: %(multipart/form-data; boundary=#{boundary})) }
      end

      context '#serialize' do
        subject { serializer.serialize }

        context 'single attachment' do
          let(:expected_value) { File.read('spec/support/fixtures/serialized_email_with_single_attachment.txt').gsub(/\n/, "\r\n").chomp }

          it { is_expected.to eq(expected_value) }
        end

        context 'multiple attachments' do
          let(:image_file) do
            VCR.use_cassette('image_file') do
              FFaker::Image.file('300x300', 'png', '3bdd27', 'ff1843')
            end
          end
          let(:second_attachment) do
            WorkApi::EmailAttachment.new.tap do |a|
              a.attach('test-image.png', image_file)
            end
          end

          let(:attachments) { [attachment, second_attachment] }

          let(:expected_value) { File.read('spec/support/fixtures/serialized_email_with_multiple_attachments.txt').gsub(/\n/, "\r\n").chomp }

          it { is_expected.to eq(expected_value) }
        end
      end
    end
  end
end
