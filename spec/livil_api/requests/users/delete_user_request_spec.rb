# frozen_string_literal: true

require 'livil_api/model/user'
require 'livil_api/requests/users/create_user_request'
require 'livil_api/requests/users/delete_user_request'

RSpec.describe(LivilApi::Requests::Users::DeleteUserRequest) do
  include_context 'with live client' do
    def token
      @token
    end
  end

  let(:arbitrary_id) { 'delete_test@livil.co' }

  before do
    new_user = LivilApi::User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid)
    path_to_private_key = File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem")
    request = LivilApi::Requests::Users::CreateUserRequest.new(body: new_user, path_to_private_key: path_to_private_key)
    result = make_request(request)

    byebug

    @token = result.token
  end

  let(:request) { described_class.new }

  context 'success' do
    let(:cassette_name) { 'user_delete_success' }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users/me') }
    end

    context 'client#call' do
      let(:response) {
        kill
        make_request(request) }

      subject { response.body }

      it { is_expected.to eq(:no_content) }
    end
  end

  xcontext 'failure' do
    let(:cassette_name) { 'user_create_failure' }

    let(:path_to_private_key) { File.join(APP_ROOT, 'tmp/livil-dummy-key.pem') }

    before do
      key = OpenSSL::PKey::RSA.new(2048)
      File.open(path_to_private_key, 'w') { |f| f.write(key.to_pem) }
    end

    after { File.delete(path_to_private_key) }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users') }
    end

    context 'client#call' do
      let(:response) { make_request(request) }

      subject { response }

      it { is_expected.to be_error }
      it { is_expected.not_to be_success }
      it { is_expected.to have_attributes(body: :no_content) }

      context 'response#errors' do
        subject { response.errors }
        it { is_expected.to have_attributes(count: 1) }

        context '#first' do
          subject { response.errors.first }
          it { is_expected.to be_a(LivilApi::Error) }
          it { is_expected.to have_attributes(message: /invalid_token_error/) }
        end
      end
    end
  end
end
