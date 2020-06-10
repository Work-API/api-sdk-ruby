# frozen_string_literal: true

require 'work_api/model/user'
require 'work_api/requests/users/reauth_user_request'

RSpec.describe(WorkApi::Requests::Users::ReauthUserRequest) do
  include_context 'with live client'

  let(:arbitrary_id) { 'create_user@livil.co' }

  let(:user) { WorkApi::User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid) }
  let(:request) { described_class.new(body: user, path_to_private_key: path_to_private_key) }

  context 'success' do
    let(:cassette_name) { 'user_reauth_success' }

    let(:path_to_private_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }

    context '#path' do
      subject { request.path }
      it { is_expected.to eq('users/reauth') }
    end

    context 'client#call' do
      let(:response) { make_request(request) }

      subject { response }

      it { is_expected.to be_a(WorkApi::Client::Response) }
      it { is_expected.to have_attributes(body: WorkApi::User) }
    end
  end

  context 'failure' do
    context 'with bad token' do
      let(:cassette_name) { 'user_reauth_failure' }

      let(:path_to_private_key) { File.join(APP_ROOT, 'tmp/livil-dummy-key.pem') }

      before do
        key = OpenSSL::PKey::RSA.new(2048)
        File.open(path_to_private_key, 'w') { |f| f.write(key.to_pem) }
      end

      after { File.delete(path_to_private_key) }

      context '#path' do
        subject { request.path }
        it { is_expected.to eq('users/reauth') }
      end

      context 'client#call' do
        let(:response) { make_request(request) }

        subject { response }

        it { is_expected.to be_error }
        it { is_expected.not_to be_success }
        it { is_expected.to have_attributes(body: :unauthorized) }

        context 'response#errors' do
          subject { response.errors }
          it { is_expected.to have_attributes(count: 1) }

          context '#first' do
            subject { response.errors.first }
            it { is_expected.to be_a(WorkApi::Error) }
            it { is_expected.to have_attributes(code: /invalid_token_error/) }
          end
        end
      end
    end
  end
end
