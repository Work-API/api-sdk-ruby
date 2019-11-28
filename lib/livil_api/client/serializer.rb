# frozen_string_literal: true

module LivilApi
  class Client
    class Serializer
      def initialize(body)
        @body = body
      end

      def serialize
        if @body.is_a?(Array)
          serialize_collection(@body)
        else
          serialize_single(@body)
        end
      end

      protected

      def serialize_single(body)
        {
          attributes: body.attributes_hash,
          type: class_name_for(body)
        }.tap do |hash|
          hash[:id] = body.id if body.id.present?
        end
      end

      # def deserialize_collection(array)
      #   array.map(&method(:deserialize_single))
      # end

      def class_name_for(model)
        model.class.name.split('::').last.underscore
      end
    end
  end
end
