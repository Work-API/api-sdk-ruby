# frozen_string_literal: true

require_relative './response'

module WorkApi
  class Client
    module Requests
      CONTENT_TYPE_JSON_API = 'application/vnd.api+json'

      private

      def get(url, params: {}, **_opts)
        raw_response = adapter.get do |request|
          request.url url, params
        end

        Response.new(raw_response)
      end

      def post(url, params: {}, body: {}, content_type: CONTENT_TYPE_JSON_API)
        execute_request(:post, url,
                        params: params,
                        body: body,
                        content_type: content_type)
      end

      def patch(url, params: {}, body: {}, content_type: CONTENT_TYPE_JSON_API)
        execute_request(:patch, url,
                        params: params,
                        body: body,
                        content_type: content_type)
      end

      def put(url, params: {}, body: {}, content_type: CONTENT_TYPE_JSON_API)
        execute_request(:put, url,
                        params: params,
                        body: body,
                        content_type: content_type)
      end

      def put_upload(url, params: {}, body: {}, headers: {})
        conn = build_connection(url)
        raw_response = with_headers(headers, conn: conn) do
          conn.put do |request|
            request.url url, params
            request.body = body
          end
        end

        Response.new(raw_response)
      end

      def execute_request(method, url, params:, body:, content_type:)
        body = JSON.dump(body) if body.is_a?(Hash)

        response = with_content_type(content_type) do
          adapter.send(method) do |request|
            request.url url, params
            request.body = body
          end
        end

        Response.new(response)
      end

      def delete(url, params: {}, **_opts)
        raw_response = adapter.delete do |request|
          request.url url, params
        end

        Response.new(raw_response)
      end

      def download(url, params: {}, **_opts)
        connection = build_connection(url)

        file = Tempfile.new(url.hash.to_s)
        file.binmode

        response = connection.get do |request|
          request.url url, params

          # TODO: rework when faraday v2(?) is released
          # as it has some streaming updates
          #
          # request.options.on_data = Proc.new do |chunk, overall|
          #   file.write(chunk)
          # end
        end

        process_response(response, io: file)
      end
    end
  end
end
