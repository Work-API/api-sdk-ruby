# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Integrations
      class CreateIntegrationRequest < BaseRequest[:post, 'integrations']; end
    end
  end
end
