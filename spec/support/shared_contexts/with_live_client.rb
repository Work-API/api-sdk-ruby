# frozen_string_literal: true

require 'tasks/common'

RSpec.shared_context 'with live client' do
  include_context 'with token'

  def make_request(request, override_cassette: nil)
    VCR.use_cassette(override_cassette || cassette_name, record: :new_episodes) do
      client.call(request, token: token)
    end
  end

  let(:cassette_name) { raise 'please specify a +cassette_name+ in your spec' }
  let(:client) { WorkApi::Client.new }
  let(:evironment_guid) { '31d6543f-5e26-4203-a258-011b5032a1c6' }
end
