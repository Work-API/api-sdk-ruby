# frozen_string_literal: true

require 'byebug'

module LivilApi
  module Serializable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :serialization_keys

      def serialize_with(*serialization_keys)
        @serialization_keys = serialization_keys
      end
    end

    def attributes_hash
      hash = super
      hash.slice!(*self.class.serialization_keys) if self.class.serialization_keys.present?

      hash
    end
  end
end
