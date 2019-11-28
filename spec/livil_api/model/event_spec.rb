# frozen_string_literal: true

require 'livil_api/model/event'

RSpec.describe(LivilApi::Event) do
  let(:remote_id) { FFaker::Guid.guid }
  let(:integration_id) { FFaker::Guid.guid }
  let(:event) { described_class.new(remote_id: remote_id, integration_id: integration_id) }

  context '#to_hash' do
    subject { event.to_hash }
    it { is_expected.to include(attributes: Hash, id: String) }
  end
end
