# frozen_string_literal: true

module LivilApi
  class BaseDeserializer
    def initialize(json)
      json = JSON.parse(json) if json.is_a?(String)
      @json = json&.with_indifferent_access

      @error_json = @json.delete(:errors)
    end

    def deserialize
      raise NotImplementedError
    end

    def errors
      @error_json&.map do |error|
        LivilApi::Error.new(code: error[:code], message: error[:detail])
      end
    end
  end
end
