# frozen_string_literal: true

require_relative './client/http'

module LivilApi
  class Client
    DEFAULT_URL = 'https://api-alpha.work-api.com'

    def service(token:)
      HTTP.new(token, url)
    end

    def call(request, token: nil)
      token = request.respond_to?(:token) ? request.token : token

      service(token: token).api_call(
        request.http_method,
        request.path,
        **request.args
      )
    end

    def self.url
      @url || ENV['LIVIL_API_HOST'] || DEFAULT_URL
    end

    private

    def url
      @url ||= self.class.url
    end
  end
end
