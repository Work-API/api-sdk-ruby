# frozen_string_literal: true

require 'tempfile'

RSpec.describe(LivilApi::AptGenerator) do
  include_context 'with environment'

  let(:path_to_private_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }
  let(:path_to_public_key) { File.join(APP_ROOT, "keys/livil-#{environment_guid}.pem") }
  let(:arbitrary_id) { 'some_user@work-api' }

  let(:token) do
    described_class.generate_apt(
      environment_guid: environment_guid,
      path_to_private_key: path_to_private_key,
      arbitrary_id: arbitrary_id
    )
  end

  context '#generate_apt' do
    subject { token }
    it { is_expected.to be_a(String) }
  end

  context '#decode_apt' do
    subject { described_class.decode_apt(token, path_to_public_key: path_to_public_key) }
    it { is_expected.to be_a(Hash) }
    it do
      is_expected.to include(
        'user' => { 'arbitrary_id' => arbitrary_id, 'environment_guid' => environment_guid }
      )
    end

    context 'with bad key' do
      let(:public_key) do
        Tempfile.create('pkey').tap do |f|
          f.write(OpenSSL::PKey::RSA.new(2048).public_key.to_s)
          f.rewind
        end
      end

      let(:path_to_public_key) { public_key.path }

      it 'should raise an error' do
        expect { subject }.to raise_error(JWT::DecodeError)
      end
    end
  end
end
