# frozen_string_literal: true

require_relative './deserializer'

module LivilApi
  class Client
    class Response
      attr_reader :raw_response

      def initialize(raw_response)
        @raw_response = raw_response
      end

      def body
        deserializer = Deserializer.new(json)
        deserializer.deserialize
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
    end
  end
end
