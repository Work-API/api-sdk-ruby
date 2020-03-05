# frozen_string_literal: true

RSpec.describe(LivilApi::Service) do
  include_context 'with service'

  let(:integration_id) { '5e5d1077390585003fd8fc68' }

  context 'list_mailboxes' do
    let(:api_method) { :list_mailboxes }

    it { is_expected.to be_a(Array) }

    context '#first' do
      subject { call.first }
      it { is_expected.to be_a(LivilApi::Mailbox) }
    end
  end
end
