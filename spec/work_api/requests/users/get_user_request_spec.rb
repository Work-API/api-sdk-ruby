# frozen_string_literal: true

require 'work_api/model/user'
require 'work_api/requests/users/get_user_request'

RSpec.describe(WorkApi::Requests::Users::GetUserRequest) do
  include_context 'with token'
  include_context 'with live client'

  let(:request) { described_class.new }

  context 'client#call' do
    subject { response }
    let(:response) { make_request(request) }

    let(:cassette_name) { 'user_get_success' }

    it { is_expected.to be_a(WorkApi::Client::Response) }
    it { is_expected.not_to be_error }
    it { is_expected.to be_success }

    context '#body' do
      subject { response.body }
      it { is_expected.to be_a(WorkApi::User) }
    end
  end
end
