# frozen_string_literal: true

require 'livil_api/model/user'
require 'livil_api/requests/users/create_user_request'

RSpec.describe(LivilApi::Requests::Users::CreateUserRequest) do
  include_context 'with live client'

  let(:arbitrary_id) { 'create_user@livil.co' }

  let(:user) { LivilApi::User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid) }
  let(:request) { described_class.new(body: user, path_to_private_key: path_to_private_key) }

  context 'success' do
    let(:cassette_name) { 'user_create_success' }

    let(:path_to_private_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users') }
    end

    context 'client#call' do
      let(:response) { make_request(request) }

      subject { response }

      it { is_expected.to be_a(LivilApi::Client::Response) }
      it { is_expected.to have_attributes(body: LivilApi::User) }
    end
  end

  context 'failure' do
    context 'with bad token' do
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
            it { is_expected.to have_attributes(code: /invalid_token_error/) }
          end
        end
      end
    end

    context 'when user with same ID already exists' do
      let(:cassette_name) { 'user_create_failure_duplicate' }
      let(:arbitrary_id) { 'create_user_dupe@livil.co' }

      context 'client#call' do
        let(:path_to_private_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }
        before { make_request(request, override_cassette: 'user_create_failure_dupe_setup') }

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
            it { is_expected.to have_attributes(code: /user_already_exists/) }
          end
        end
      end
    end
  end
end
