# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Integrations
      class ModifyIntegrationRequest < BaseRequest[:put, 'integrations/{integration_id}', %i[integration_id]]; end
    end
  end
end
