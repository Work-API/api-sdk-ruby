# frozen_string_literal: true

require_relative '../base_request'
require 'work_api/deserializers/json_deserializer'

module WorkApi
  module Requests
    module Integrations
      VALID_PARAMS = %i[integration_id redirect return_to].freeze

      class AuthIntegrationRequest < BaseRequest[:get, 'auth/init/{integration_id}', VALID_PARAMS]
        def deserializer_class
          JsonDeserializer
        end
      end
    end
  end
end
