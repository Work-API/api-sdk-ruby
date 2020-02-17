# frozen_string_literal: true

require_relative './deserializer'

module LivilApi
  class Client
    class Response
      attr_reader :raw_response
      delegate :success?, to: :raw_response

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
        errors.present?
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

      protected

      def deserializer
        @deserializer ||= Deserializer.new(json)
      end
    end
  end
end
