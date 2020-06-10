# frozen_string_literal: true

require 'base64'

module WorkApi
  module WithCompositeId
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module_function

    def encode_id(integration_id, remote_id)
      raise MissingIdSegmentError, :integration_id if integration_id.empty?
      raise MissingIdSegmentError, :remote_id if remote_id.empty?

      compound_id = "#{integration_id}:#{remote_id}"

      # avoid base64 suffix '=='
      compound_id += ':' while compound_id.length % 3 != 0

      Base64.urlsafe_encode64(compound_id)
    end

    def decode_id(id, segment = nil)
      raw = Base64.urlsafe_decode64(id)
      segments = raw.split(':')
      integration_id = segments.shift
      remote_id = segments.join(':')

      decoded = {
        integration_id: integration_id,
        remote_id: remote_id
      }

      return decoded if segment.nil?

      decoded[segment]
    end

    module ClassMethods
      def new(**args)
        id = args.delete(:id)
        assign_id_components(args, id) unless id&.empty?
        super(**args)
      end

      protected

      def assign_id_components(hash, id)
        return if id.blank?

        %i[integration_id remote_id].each do |key|
          hash[key] = WithCompositeId.decode_id(id, key)
        end
      end
    end

    module InstanceMethods
      def id
        @id ||= WithCompositeId.encode_id(integration_id, remote_id)
      end

      def new?
        integration_id.blank? || remote_id.blank?
      end
    end
  end
end
