# frozen_string_literal: true

require 'work_api/model/event'

RSpec.describe(WorkApi::Event) do
  let(:remote_id) { FFaker::Guid.guid }
  let(:integration_id) { FFaker::Guid.guid }
  let(:event) { described_class.new(remote_id: remote_id, integration_id: integration_id) }

  context '#to_hash' do
    subject { event.to_hash }
    it do
      is_expected
        .to include(
          :all_day, :attachments, :attendees, :created_at, :description,
          :end_date_time, :end_timezone, :integration_id, :location,
          :name, :recurrence, :reminders, :remote_id, :start_date_time,
          :start_timezone, :updated_at
        )
    end
  end
end
