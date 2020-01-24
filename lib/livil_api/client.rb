# frozen_string_literal: true

require_relative './client/http'

module LivilApi
  class Client
    DEFAULT_URL = 'https://api-dev.livil.io'

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

    private

    def url
      @url || ENV['LIVIL_API_HOST'] || DEFAULT_URL
    end
  end
end
