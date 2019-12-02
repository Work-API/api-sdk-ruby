# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Integrations
      class DestroyIntegrationRequest < BaseRequest[:delete, 'integrations/{integration_id}']; end
    end
  end
end
