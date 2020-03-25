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
        status
      end
    end

    protected

    def deserialize_single(hash, use_included: false)
      id, type, attributes, relationships = hash.slice(:id, :type, :attributes, :relationships).values

      attributes = build_single_attrs(id, type, attributes, use_included)
      model = instantiate_model(type, attributes)
      assign_relationships(model, relationships)

      model
    end

    def build_single_attrs(id, type, attributes, use_included)
      if use_included
        included_item = get_included(id, type)
        attributes = included_item[:attributes] if included_item.present?
      end

      { id: id }.tap do |attrs|
        attrs.merge!(attributes.deep_symbolize_keys) unless attributes.nil?
      end
    end

    def instantiate_model(type, attributes)
      class_for(type).new(**attributes)
    end

    def deserialize_collection(array)
      array.map(&method(:deserialize_single))
    end

    def assign_relationships(model, relationships)
      return if relationships.nil?

      relationships.each_pair do |type, relationship|
        relationship[:data].map do |item_hash|
          model.send(type).send(:<<, deserialize_single(item_hash, use_included: true))
        end
      end
    end

    def get_included(id, type)
      @json['included'].find do |included_hash|
        included_hash['id'] == id && included_hash['type'] == type
      end
    end

    def class_for(type)
      LivilApi.const_get(type.classify)
    end
  end
end
