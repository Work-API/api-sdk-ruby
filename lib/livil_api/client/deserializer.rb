# frozen_string_literal: true

module LivilApi
  class Client
    class Deserializer
      def initialize(json)
        @json = json
      end

      def deserialize
        data = @json[:data]

        if data.is_a?(Array)
          deserialize_collection(data)
        else
          deserialize_single(data)
        end
      end

      protected

      def deserialize_single(hash)
        id, type, attributes = hash.slice(:id, :type, :attributes).values
        class_for(type).new(id: id, **attributes.symbolize_keys)
      end

      def deserialize_collection(array)
        array.map(&method(:deserialize_single))
      end

      def class_for(type)
        LivilApi.const_get(type.classify)
      end
    end
  end
end
