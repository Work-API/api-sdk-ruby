# frozen_string_literal: true

require_relative './base_serializer'

module WorkApi
  class JsonapiSerializer < BaseSerializer
    def serialize
      if @body.is_a?(Array)
        serialize_collection(@body)
      else
        serialize_single(@body)
      end
    end

    def content_type
      'application/vnd.api+json'
    end

    protected

    def serialize_single(model)
      {
        attributes: model.attributes_hash,
        type: class_name_for(model)
      }.tap do |hash|
        hash[:id] = model.id unless model.new?
      end
    end
  end
end
