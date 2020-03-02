# frozen_string_literal: true

require_relative '../client/serializer'

module LivilApi
  module Requests
    class BaseRequest
      class << self
        def [](http_method, path, **opts)
          Class.new(BaseRequest).tap do |klass|
            klass.define_singleton_method(:base_path, -> { path })
            klass.define_singleton_method(:http_method, -> { http_method })
            klass.define_singleton_method(:opts, -> { opts })
          end
        end
      end

      attr_accessor :response, :params
      attr_accessor :deserializer_class

      def initialize(body: nil, **params)
        @body = body
        @params = params

        validate!
      end

      def validate!
        # override in subclasses
      end

      def args
        { params: params }.tap do |hash|
          hash[:body] = { data: body } if body.present?
        end
      end

      def body
        return if @body.nil?

        serializer = Client::Serializer.new(@body)
        serializer.serialize
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
