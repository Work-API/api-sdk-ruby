# frozen_string_literal: true

require_relative '../base_request'
require 'livil_api/deserializers/json_deserializer'

module LivilApi
  module Requests
    module Integrations
      class AuthIntegrationRequest < BaseRequest[:get, 'auth/init/{integration_id}']
        def deserializer_class
          JsonDeserializer
        end
      end
    end
  end
end
