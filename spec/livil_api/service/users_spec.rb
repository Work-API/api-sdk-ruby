# frozen_string_literal: true

RSpec.describe(LivilApi::Service::Users) do
  include_context 'with service'

  context 'create_user' do
    let(:api_method) { :create_user }

    let(:arbitrary_id) { 'another_create_user@livil.co' }
    let(:path_to_private_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }
    let(:user) { LivilApi::User.new(environment_guid: environment_guid, arbitrary_id: arbitrary_id) }

    let(:args) do
      {
        user: user,
        path_to_private_key: path_to_private_key
      }
    end

    it { is_expected.to be_a(LivilApi::User) }
  end
end
