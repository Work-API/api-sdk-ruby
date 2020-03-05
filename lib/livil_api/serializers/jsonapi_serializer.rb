# frozen_string_literal: true

require_relative './base_serializer'

module LivilApi
  class JsonapiSerializer < BaseSerializer
    def serialize
      if @body.is_a?(Array)
        serialize_collection(@body)
      else
        serialize_single(@body)
      end
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

    def class_name_for(model)
      model.class.name.split('::').last.underscore
    end
  end
end
