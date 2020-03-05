# frozen_string_literal: true

require 'livil_api/service/users'
require 'livil_api/service/integrations'
require 'livil_api/service/events'

module LivilApi
  class Service
    include Events
    include Integrations
    include Users

    def initialize(token = nil)
      @token = token
    end

    protected

    def call(request)
      client.call(request, token: @token)
    end

    def client
      @client ||= Client.new
    end
  end
end
