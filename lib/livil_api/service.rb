# frozen_string_literal: true

require 'livil_api/service/users'
require 'livil_api/service/integrations'
require 'livil_api/service/events'
require 'livil_api/service/emails'

module LivilApi
  class Service
    include Users
    include Integrations
    include Events
    include Emails

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
