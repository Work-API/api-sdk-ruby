# frozen_string_literal: true

require 'jwt'
require 'openssl'

module LivilApi
  class AptGenerator
    ALGORITHM = 'RS256'
    ISSUER = "Livil Ruby SDK v#{VERSION}"

    class << self
      # Generates an Account Provider Token (APT)
      #
      # @param [String] environment_guid:
      # @param [String] path_to_private_key: The local path to the environment's private key file
      # @param [String] arbitrary_id: Belonging to the user account which will be accessed with the APT
      # @param [Number] expiry:
      #
      # @return [String] token
      def generate_apt(environment_guid:, path_to_private_key:, arbitrary_id: nil, expiry: 60)
        user = { environment_guid: environment_guid }.tap do |h|
          h[:arbitrary_id] = arbitrary_id if arbitrary_id.present?
        end

        JWT.encode(
          build_payload(user, ttl: expiry),
          load_key(path_to_private_key),
          ALGORITHM
        )
      end

      # Decodes and validates a previously created APT using the environment's public key file
      #
      # @param [String] token The APT to decode
      # @param [String] path_to_public_key: The local path to the environment's public key file
      #
      # @raise [JWT::VerificationError, JWT::DecodeError, JWT::ExpiredSignature]
      #
      # @return [Hash] the payload of the APT
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
        raw_key = ::File.read(path_to_key)
        OpenSSL::PKey::RSA.new(raw_key)
      end

      def build_payload(user, ttl:)
        {
          exp: Time.now.to_i + ttl,
          iat: Time.now.to_i,
          iss: ISSUER,
          user: user
        }
      end
    end
  end
end
