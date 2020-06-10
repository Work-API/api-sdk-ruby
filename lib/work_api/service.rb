# frozen_string_literal: true

require 'work_api/service/error_handling'
require 'work_api/service/users'
require 'work_api/service/integrations'
require 'work_api/service/events'
require 'work_api/service/emails'

module WorkApi
  class Service
    include ErrorHandling
    include Users
    include Integrations
    include Events
    include Emails

    def initialize(token = nil)
      @token = token
    end

    protected

    def call(request)
      response = client.call(request, token: @token)

      handle_errors(request, response) if response.error?

      response
    end

    def client
      @client ||= Client.new
    end
  end
end
