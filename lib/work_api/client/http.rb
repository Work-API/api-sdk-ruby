# frozen_string_literal: true

require_relative './requests'
require 'faraday'
require 'uuidtools'

module WorkApi
  class Client
    module ParamsEncoderBypass
      def self.encode(params)
        params
          .each_pair
          .each_with_object([]) do |(key, value), arr|
            arr << "#{key}=#{value}"
          end
          .join('&')
      end

      def self.decode(params)
        params
          .split('&')
          .map { |str| str.split('=') }
          .each_with_object({}) do |(key, value), hash|
            hash[key] = value
          end
      end
    end

    class HTTP
      DEFAULT_CONTENT_TYPE = 'application/vnd.api+json'

      def initialize(token, api_url, content_type = nil)
        @token = token
        @api_url = api_url
        @content_type = content_type
      end

      def api_call(method, url, **opts)
        response = send(method, url.to_s, **opts, content_type: @content_type)

        if response.respond_to?(:status)
          process_response(response, redirect_method: opts[:redirect_method])
        else
          response
        end
      end

      include Requests

      private

      attr_accessor :api_url, :token

      def adapter
        @adapter ||= Faraday.new(url: api_url) do |conn|
          apply_cx_defaults(conn)
        end
      end

      def with_content_type(content_type, &block)
        with_headers({ 'Content-Type' => content_type }, &block)
      end

      def with_headers(headers = {}, conn: nil)
        conn ||= adapter

        prev = headers.each_pair.each_with_object({}) do |(key, value), hash|
          hash[key] = conn.headers[key]
          conn.headers[key] = value
        end

        result = yield

        headers.each_pair do |key, _value|
          conn.headers[key] = prev[key]
        end

        result
      end

      def process_response(response, redirect_method: nil, io: nil)
        case response.status
        when 200..203
          handle_success(response, io: io)
        when 204
          {}
        when 300..399
          handle_redirect(response, redirect_method)
        when 400..499, 500..599
          handle_error(response)
        end
      end

      def handle_success(response, io: nil)
        return handle_io(response, io) if io

        return { 'code' => response.status } if response.body.empty?

        JSON.parse(response.body)
      end

      def handle_io(response, io)
        io.tap do |i|
          i.write(response.body)
          i.rewind
          i.close
        end
        { io: io }
      end

      def handle_redirect(response, method)
        location = response.headers['location']
        return handle_error(response) unless location.present?

        api_call(method || :get, location)
      end

      def handle_error(response)
        error_info = response.body.empty? ? '' : JSON.parse(response.body)
        {
          error_code: response.status,
          error: error_info
        }
      end

      def build_connection(url)
        # If we're fetching from a fully qualifyied URL
        if url.match?(/http/)
          # Faraday's default param encoders reorder the parameters, thereby invalidating
          # the signature on the URL
          Faraday.new(request: { params_encoder: ParamsEncoderBypass }) do |conn|
            apply_cx_defaults(conn, with_headers: false)
          end
        else
          adapter
        end
      end

      def apply_cx_defaults(conn, with_headers: true)
        conn.adapter Faraday.default_adapter

        return unless with_headers

        conn.headers = {
          'Authorization' => "Bearer #{token}",
          'Accept' => DEFAULT_CONTENT_TYPE
        }
      end
    end
  end
end
