# frozen_string_literal: true

RSpec.shared_context 'with live client' do
  include_context 'with token'

  def make_request(request)
    VCR.use_cassette(cassette_name, record: :new_episodes) do
      client.call(request, token: token)
    end
  end

  let(:cassette_name) { raise 'please specify a +cassette_name+ in your spec' }
  let(:client) { LivilApi::Client.new }
end
