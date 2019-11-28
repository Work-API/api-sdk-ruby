# frozen_string_literal: true

module LivilApi
  module BaseModel
    def self.included(base)
      base.class_eval do
        alias_method :pb_to_hash, :to_hash
        alias_method :attributes_hash, :to_hash
      end
    end

    module ClassMethods
      def from_attrs(**args)
        new(**args.deep_symbolize_keys)
      end
    end
  end
end
