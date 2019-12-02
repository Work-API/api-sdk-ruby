# frozen_string_literal: true

require 'active_support/core_ext/hash'

require 'livil_api/version'

require 'livil_api/model/user'
require 'livil_api/model/integration'
require 'livil_api/model/event'

require 'livil_api/requests/users/create_user_request'
require 'livil_api/requests/integrations/list_integrations_request'
require 'livil_api/requests/integrations/create_integration_request'
require 'livil_api/requests/integrations/auth_integration_request'
require 'livil_api/requests/integrations/destroy_integration_request'
require 'livil_api/requests/events/list_events_request'

require 'livil_api/client'
require 'livil_api/service'
require 'livil_api/configuration'

module LivilApi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
