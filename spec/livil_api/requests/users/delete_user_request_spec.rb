# frozen_string_literal: true

require 'livil_api/model/user'
require 'livil_api/requests/users/create_user_request'
require 'livil_api/requests/users/delete_user_request'

RSpec.describe(LivilApi::Requests::Users::DeleteUserRequest) do
  include_context 'with live client' do
    attr_reader :token
  end

  let(:arbitrary_id) { 'delete_test_two@livil.co' }
  let(:request) { described_class.new }

  context 'success' do
    let(:cassette_name) { 'user_delete_success' }

    before do
      new_user = LivilApi::User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid)
      path_to_private_key = File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem")
      request = LivilApi::Requests::Users::CreateUserRequest.new(body: new_user, path_to_private_key: path_to_private_key)
      result = make_request(request)

      @token = result.body.token
    end

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users/me') }
    end

    context 'client#call' do
      let(:response) { make_request(request) }

      subject { response.body }

      it { is_expected.to eq(:no_content) }
    end
  end

  context 'failure' do
    let(:cassette_name) { 'user_delete_failure' }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users/me') }
    end

    context 'client#call' do
      let(:cassette_name) { 'user_delete_failure' }

      let(:response) { make_request(request) }

      context '#body' do
        subject { response.body }
        it { is_expected.to eq(:no_content) }
      end

      context '#errors#first' do
        subject { response.errors.first }
        it { is_expected.to be_a(LivilApi::Error) }
        it { is_expected.to have_attributes(code: 'invalid_token_error', message: /invalid token/) }
      end
    end
  end
end
