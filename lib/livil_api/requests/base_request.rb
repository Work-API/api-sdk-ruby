# frozen_string_literal: true

module LivilApi
  module Requests
    class BaseRequest
      attr_accessor :response, :params
      attr_accessor :deserializer_class, :serializer_class

      class << self
        def [](http_method, path, accepted_params = [], **opts)
          Class.new(self).tap do |klass|
            klass.define_singleton_method(:http_method, -> { http_method })
            klass.define_singleton_method(:base_path, -> { path })
            klass.define_singleton_method(:accepted_params, -> { accepted_params })
            klass.define_singleton_method(:opts, -> { opts })
          end
        end
      end

      def initialize(body: nil, **params)
        @body = body
        @params = params

        validate!
      end

      def validate!
        invalid_params = @params.keys.reject { |key| self.class.accepted_params.include?(key) }
        raise ArgumentError, "invalid parameters for #{self.class.name}: #{invalid_params.join(', ')}" if invalid_params.present?
      end

      def args
        { params: params }.tap do |hash|
          hash[:body] = body if body.present?
        end
      end

      def body
        return if @body.nil?

        serialized = @body.serializer.serialize

        case content_type
        when /api\+json/
          { data: serialized }
        else
          serialized
        end
      end

      def content_type
        @body&.serializer&.content_type
      end

      def http_method
        self.class.http_method
      end

      def path
        interpolate_path(self.class.base_path)
      end

      def interpolate_path(path)
        interpolated_path = path.clone

        path.scan(/({[^}]+})/).flatten.each do |segment|
          segment_key = segment.gsub(/[{}]/, '').to_sym
          interpolated_path = interpolated_path.gsub(segment, params.delete(segment_key))
        end

        interpolated_path
      end

      def process_response(response)
        if opts[:collection]
          # handle multiple results
        else
          @response = response
        end
      end
    end
  end
end
