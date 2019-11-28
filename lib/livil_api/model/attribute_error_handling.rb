# frozen_string_literal: true

module LivilApi
  module AttributeErrorHandling
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def new(**args)
        super(**args)
      rescue ArgumentError => e
        handle_attribute_error(e) || raise
      end

      protected

      def handle_attribute_error(error)
        matches = error.message.match(/Unknown field name '([^']+)' in initialization map entry/)
        raise ParameterError, "Unknown attribute: #{matches[1]}" if matches.present?
      end
    end
  end
end
