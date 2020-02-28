# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Integrations
      class ModifyIntegrationRequest < BaseRequest[:put, 'integrations/{integration_id}']; end
    end
  end
end
