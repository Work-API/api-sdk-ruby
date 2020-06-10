# frozen_string_literal: true

require_relative './base_deserializer'

module WorkApi
  class JsonDeserializer < BaseDeserializer
    def deserialize
      if @json.blank?
        status
      else
        @json
      end
    end
  end
end
