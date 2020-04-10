# frozen_string_literal: true

module LivilApi
  module Attribute
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def new(**args)
        preprocess_args(args)
        super(**args)
      end

      def attribute(key, opts)
        attributes[key] = opts
      end

      protected

      def attributes
        @attributes ||= {}
      end

      def preprocess_args(args)
        attributes.each_pair do |key, options|
          next if nullable?(key)

          apply_default(args, key, options[:default]) if options[:default].present?
        end
      end

      def apply_default(args, key, default)
        args[key] = default unless args.key?(key)
      end

      def nullable?(attr)
        attributes.dig(attr, :nullable)
      end
    end
  end
end
