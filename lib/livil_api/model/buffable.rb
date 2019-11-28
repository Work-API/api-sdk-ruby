# frozen_string_literal: true

require 'spico/utils/protobuf_extensions'

module Spico
  module Buffable
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, ProtobufExtensions)
    end

    module ClassMethods
      # Public: Macro to convert instances of the calling class to a Protobuf
      #
      # protobuf_class - The Google::Protobuf::Descriptor output type (e.g. Spico::Protobufs::Email)
      # fields         - The Array of Symbols and Hashes for mapping between classes
      #
      # Examples
      #
      #   class ProtobufModel
      #     # ...
      #     # has definitions for 'username' and 'email'
      #     # ...
      #   end
      #
      #   class MyModel
      #     protobuf ProtobufModel, :username, email: :email_address
      #
      #     def username
      #       # ...
      #     end
      #
      #     def email_address
      #       # ...
      #     end
      #   end
      def protobuf(protobuf_class, *fields)
        @protobuf_class = protobuf_class
        @protobuf_fields = fields

        define_method(:to_proto) do
          self.class.convert_to_protobuf(self)
        end
      end

      def convert_to_protobuf(object)
        @protobuf_fields.each_with_object(@protobuf_class.new) do |field, pb|
          if field.is_a?(Symbol)
            obj_accessor = pb_accessor = field
          else
            pb_accessor, obj_accessor = field.to_a.flatten
          end

          update_field(object, obj_accessor, pb, pb_accessor)
        end
      end

      # Public: Macro to transparently transform between Google::Protobuf::Any and a contained protobuf class
      #
      # fields - The accessors to replace with the transformation macro
      def transform_proto_any(property)
        define_transform_any_reader(property)
        define_transform_any_writer(property)
        define_transform_any_constructor(property)
      end

      def define_transform_any_constructor(property)
        metaclass.send(:define_method, :new) do |**args|
          bypass_val = args.delete(property)
          object = super(**args)
          object.send("#{property}=", bypass_val) unless bypass_val.nil?
          object
        end
      end

      def define_transform_any_reader(property)
        define_method(property) do
          property_hash = to_hash[property]
          return nil if property_hash.nil?

          any = Google::Protobuf::Any.new(to_hash[property])
          descriptor = Google::Protobuf::DescriptorPool.generated_pool.lookup(any.type_name)
          any.unpack(descriptor.msgclass)
        end
      end

      def define_transform_any_writer(property)
        define_method("#{property}=".to_sym) do |value|
          value = Google::Protobuf::Any.pack(value) unless value.is_a?(Google::Protobuf::Any)
          super(value)
        end
      end

      protected

      def update_field(object, obj_accessor, protob, pb_accessor)
        value = object.send(obj_accessor)

        if value.is_a?(Array)
          update_repeated_value(protob, pb_accessor, value)
        else
          update_single_value(protob, pb_accessor, value)
        end
      end

      def update_repeated_value(protob, pb_accessor, value)
        receiver = protob.send(pb_accessor)

        value.each do |item|
          item = item.to_proto if item.respond_to?(:to_proto)
          receiver << item unless item.nil?
        end
      end

      def update_single_value(protob, pb_accessor, value)
        value = value.to_proto if value.respond_to?(:to_proto)
        protob.send(:"#{pb_accessor}=", value) unless value.nil?
      end

      def metaclass
        class << self
          self
        end
      end
    end
  end
end
