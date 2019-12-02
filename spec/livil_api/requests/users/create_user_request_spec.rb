# frozen_string_literal: true

require 'livil_api/model/user'
require 'livil_api/client'
require 'livil_api/requests/users/create_user_request'

RSpec.describe(LivilApi::Requests::Users::CreateUserRequest) do
  let(:arbitrary_id) { 'someone@livil.co' }
  let(:environment_guid) { '6dbc578e-dff4-4fed-bfd0-2133a88a03e3' }
  let(:user) { LivilApi::User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid) }
  let(:client) { LivilApi::Client.new }
  let(:request) do
    described_class.new(
      body: user,
      path_to_private_key: "spec/support/fixtures/livil-#{environment_guid}.pem"
    )
  end

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('users') }
  end

  context 'client#call' do
    subject do
      VCR.use_cassette('create_user') do
        client.call(request)
      end
    end

    it { is_expected.to be_a(LivilApi::Client::Response) }
    it { is_expected.to have_attributes(body: LivilApi::User) }
  end
end
