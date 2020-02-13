# frozen_string_literal: true

require 'openssl'
require 'spico/user_authentication'

module LivilApi
  class AptGenerator
    ALGORITHM = 'RS256'
    ISSUER = "Livil Ruby SDK v#{VERSION}"

    class << self
      def generate_apt(environment_guid:, path_to_private_key:, arbitrary_id: nil, expiry: 60)
        payload = { environment_guid: environment_guid }.tap do |h|
          h[:arbitrary_id] = arbitrary_id if arbitrary_id.present?
        end

        Spico::UserAuthentication.generate_token(
          payload,
          key: load_key(path_to_private_key),
          ttl: expiry,
          algorithm: ALGORITHM
        )
      end

      def decode_apt(token, path_to_public_key:)
        payload, _header = JWT.decode(
          token,
          load_key(path_to_public_key),
          true,
          algorithm: ALGORITHM,
          iss: ISSUER
        )

        payload
      end

      private

      def load_key(path_to_key)
        raw_key = File.read(path_to_key)
        OpenSSL::PKey::RSA.new(raw_key)
      end
    end
  end
end
