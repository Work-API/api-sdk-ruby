# frozen_string_literal: true

require_relative './base_deserializer'
require 'ostruct'

module WorkApi
  class JsonapiDeserializer < BaseDeserializer
    def initialize(*)
      super

      @meta_json = @json&.delete('meta')
    end

    def deserialize
      data = @json[:data] if @json.present?

      case data
      when Array
        deserialize_collection(data, doc_root: true)
      when Hash
        deserialize_single(data, meta: meta)
      when {}, nil
        status
      end
    end

    def meta
      return if @meta_json.nil?

      @meta ||= OpenStruct.new(@meta_json)
    end

    protected

    def deserialize_single(hash, use_included: false, meta: nil)
      id, type, attributes, relationships = hash.slice(:id, :type, :attributes, :relationships).values

      attributes = build_single_attrs(id, type, attributes, use_included)
      model = instantiate_model(type, attributes)
      assign_relationships(model, relationships)

      model.meta = meta if meta.present?

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

    def deserialize_collection(array, doc_root: false)
      array.map(&method(:deserialize_single)).tap do |arr|
        break unless doc_root

        meta_hash = meta
        arr.define_singleton_method(:meta) { meta_hash }
      end
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
      @json['included']&.find do |included_hash|
        included_hash['id'] == id && included_hash['type'] == type
      end
    end

    def class_for(type)
      WorkApi.const_get(type.classify)
    end
  end
end
