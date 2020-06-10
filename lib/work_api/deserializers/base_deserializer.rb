# frozen_string_literal: true

module WorkApi
  class BaseDeserializer
    def initialize(json, http_reason_phrase = :unknown)
      json = JSON.parse(json) if json.is_a?(String)
      @json = json&.with_indifferent_access
      @http_reason_phrase = http_reason_phrase

      @error_json = @json&.delete(:errors)
    end

    attr_reader :http_reason_phrase

    def deserialize
      raise NotImplementedError
    end

    def status
      http_reason_phrase
        .force_encoding(Encoding::UTF_8)
        .parameterize(separator: '_')
        .to_sym
    end

    def errors
      @error_json&.map do |error|
        WorkApi::Error.new(code: error[:code], message: error[:detail])
      end
    end
  end
end
