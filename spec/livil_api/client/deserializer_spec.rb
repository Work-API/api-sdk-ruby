# frozen_string_literal: true

RSpec.describe(LivilApi::Client::Deserializer) do
  context '#errors' do
    let(:json) do
      {
        errors: [
          { code: 'something_went_wrong', detail: 'It was really bad' },
          { code: 'i_cried', detail: 'oh, the humanity' }
        ]
      }
    end

    let(:deserializer) { described_class.new(json) }

    subject { deserializer.errors }

    it { is_expected.to be_an(Array) }

    context '#first' do
      subject { deserializer.errors.first }
      it { is_expected.to be_a(LivilApi::Error) }
    end
  end
end
