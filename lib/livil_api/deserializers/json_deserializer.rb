# frozen_string_literal: true

require_relative './base_deserializer'

module LivilApi
  class JsonDeserializer < BaseDeserializer
    def deserialize
      if @json.blank?
        :no_content
      else
        @json
      end
    end
  end
end
