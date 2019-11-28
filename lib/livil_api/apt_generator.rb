# frozen_string_literal: true

require 'openssl'
require 'jwt'

module LivilApi
  class AptGenerator
    ALGORITHM = 'RS256'

    def self.generate_apt(environment_guid:, path_to_private_key:, expiry: 60, issuer: nil)
      payload = {
        exp: Time.now.to_i + expiry,
        iat: Time.now.to_i,
        iss: issuer || "Livil Ruby SDK v#{VERSION}",
        user: { environment_guid: environment_guid }
      }

      raw_private_key = File.read(path_to_private_key)
      private_key = OpenSSL::PKey::RSA.new(raw_private_key)

      JWT.encode(payload, private_key, ALGORITHM)
    end
  end
end
