# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Integrations
      class AuthIntegrationRequest < BaseRequest[:get, 'auth/init/{integration_id}']; end
    end
  end
end
