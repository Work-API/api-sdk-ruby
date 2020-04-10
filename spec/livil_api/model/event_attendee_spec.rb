# frozen_string_literal: true

RSpec.describe(LivilApi::EventAttendee) do
  context '#response_status' do
    let(:model) { described_class.new }

    subject { model.response_status }

    context 'default value' do
      it { is_expected.to eq('needsAction') }
    end

    context 'value provided' do
      let(:model) { described_class.new(response_status: 'accepted') }
      it { is_expected.to eq('accepted') }
    end
  end
end
