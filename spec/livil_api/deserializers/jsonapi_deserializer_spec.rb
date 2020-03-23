# frozen_string_literal: true

RSpec.describe(LivilApi::JsonapiDeserializer) do
  let(:deserializer) { described_class.new(json) }

  context '#errors' do
    let(:json) do
      {
        errors: [
          { code: 'something_went_wrong', detail: 'It was really bad' },
          { code: 'i_cried', detail: 'oh, the humanity' }
        ]
      }
    end

    subject { deserializer.errors }

    it { is_expected.to be_an(Array) }

    context '#first' do
      subject { deserializer.errors.first }
      it { is_expected.to be_a(LivilApi::Error) }
    end
  end

  context '#deserialize' do
    context 'single item' do
      let(:email_id) { Base64.strict_encode64('integration1:email1') }
      let(:mailbox_id) { Base64.strict_encode64('integration1:mailbox1') }
      let(:json) do
        {
          data: {
            id: email_id,
            type: 'email',
            attributes: {
              subject: 'test subject'
            },
            relationships: {
              mailboxes: {
                data: [
                  { id: mailbox_id, type: 'mailbox' }
                ]
              }
            }
          },
          included: [
            { id: mailbox_id, type: 'mailbox', attributes: { name: 'inbox' } }
          ]
        }
      end

      let(:deserialized) { deserializer.deserialize }
      subject { deserialized }

      it { is_expected.to be_a(LivilApi::Email) }

      context 'mailboxes' do
        subject { deserialized.mailboxes }
        it { is_expected.to be_a(Google::Protobuf::RepeatedField) }

        context '#first' do
          subject { deserialized.mailboxes.first }
          it { is_expected.to be_a(LivilApi::Mailbox) }
          it do
            is_expected.to have_attributes(name: 'inbox')
          end
        end
      end
    end
  end
end
