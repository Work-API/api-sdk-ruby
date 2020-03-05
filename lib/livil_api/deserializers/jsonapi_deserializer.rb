# frozen_string_literal: true

require_relative './base_deserializer'

module LivilApi
  class JsonapiDeserializer < BaseDeserializer
    def deserialize
      data = @json[:data] if @json.present?

      case data
      when Array
        deserialize_collection(data)
      when Hash
        deserialize_single(data)
      when {}, nil
        :no_content
      end
    end

    protected

    def deserialize_single(hash)
      id, type, attributes = hash.slice(:id, :type, :attributes).values
      class_for(type).new(id: id, **attributes.deep_symbolize_keys)
    end

    def deserialize_collection(array)
      array.map(&method(:deserialize_single))
    end

    def class_for(type)
      LivilApi.const_get(type.classify)
    end
  end
end