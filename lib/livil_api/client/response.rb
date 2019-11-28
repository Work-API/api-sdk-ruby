# frozen_string_literal: true

require_relative './deserializer'

module LivilApi
  class Client
    class Response
      def initialize(raw_response)
        @raw_response = raw_response
      end

      def model
        deserializer = Deserializer.new(json)
        deserializer.deserialize
      end

      def json
        JSON.parse(@raw_response.body).with_indifferent_access
      end
    end
  end
end
