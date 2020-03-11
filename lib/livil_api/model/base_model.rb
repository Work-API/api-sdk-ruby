# frozen_string_literal: true

require_relative 'serializable'

module LivilApi
  module BaseModel
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :include, Serializable

      base.class_eval do
        alias_method :pb_to_hash, :to_hash
      end
    end

    module InstanceMethods
      def new?
        id.blank?
      end

      def serializer
        @serializer ||= JsonapiSerializer.new(self)
      end

      def attributes_hash
        to_hash
      end
    end
  end
end
