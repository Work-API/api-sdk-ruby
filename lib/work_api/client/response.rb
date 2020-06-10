# frozen_string_literal: true

require 'work_api/deserializers/jsonapi_deserializer'

module WorkApi
  class Client
    class Response
      attr_accessor :request
      attr_reader :raw_response

      delegate :success?, to: :raw_response

      DEFAULT_DESERIALIZER = JsonapiDeserializer

      def initialize(raw_response)
        @raw_response = raw_response
      end

      def body
        @body ||= deserializer.deserialize
      end

      def errors
        @errors ||= deserializer.errors
      end

      def error?
        errors.present? || (400..599).include?(@raw_response.status)
      end

      def http_code
        @raw_response.status
      end

      def json
        return if @raw_response.body.blank?

        JSON.parse(@raw_response.body).with_indifferent_access
      end

      def redirect?
        redirect_uri.present?
      end

      def redirect_uri
        json[:uri]
      end

      def http_reason_phrase
        raw_response.reason_phrase
      end

      protected

      def deserializer
        @deserializer ||= deserializer_class.new(json, http_reason_phrase)
      end

      def deserializer_class
        request.deserializer_class || DEFAULT_DESERIALIZER
      end
    end
  end
end
