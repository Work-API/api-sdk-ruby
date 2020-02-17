# frozen_string_literal: true

require 'livil_api/model/user'
require 'livil_api/requests/users/get_user_request'

RSpec.describe(LivilApi::Requests::Users::GetUserRequest) do
  include_context 'with token'
  include_context 'with live client'

  let(:request) { described_class.new }

  context 'client#call' do
    subject { response }
    let(:response) { make_request(request) }

    let(:cassette_name) { 'user_get_success' }

    it { is_expected.to be_a(LivilApi::Client::Response) }
    it { is_expected.not_to be_error }
    it { is_expected.to be_success }

    context '#body' do
      subject { response.body }
      it { is_expected.to be_a(LivilApi::User) }
    end
  end
end
