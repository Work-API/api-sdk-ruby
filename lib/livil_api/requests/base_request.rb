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

      def initialize(body: nil, **params)
        @body = body
        @params = params

        validate!
      end

      def validate!
        # override in subclasses
      end

      def args
        { body: { data: body }, params: params }
      end

      def body
        serializer = Client::Serializer.new(@body)
        serializer.serialize
      end

      def http_method
        self.class.http_method
      end

      def path
        self.class.base_path
      end

      def process_response(response)
        if opts[:collection]
          # handle multiple results
        else
          @response = response
        end
      end

      def token
        LivilApi.configure
      end
    end
  end
end
