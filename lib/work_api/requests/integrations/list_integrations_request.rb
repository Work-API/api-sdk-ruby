# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Integrations
      class ListIntegrationsRequest < BaseRequest[:get, 'integrations']; end
    end
  end
end
