# frozen_string_literal: true

require_relative './base_serializer'
require 'securerandom'

module WorkApi
  class MultipartSerializer < BaseSerializer
    NEWLINE = "\r\n"

    def serialize
      serialize_single
    end

    def content_type
      %(multipart/form-data; boundary=#{boundary})
    end

    protected

    def serialize_single
      [
        %(--#{boundary}),
        %(Content-Disposition: #{content_disposition(@body)}),
        'Content-Type: application/vnd.api+json',
        '',
        JSON.pretty_generate(data: serialized_model).gsub(/\n/, "\r\n"),
        '',
        %(--#{boundary}),
        serialized_parts
      ].flatten.join(NEWLINE)
    end

    def serialized_parts
      subsequent_parts
        .map { |part| serialize_part(part) }
        .join(NEWLINE) + '--'
    end

    def serialize_part(part)
      upload = part.upload
      [
        %(Content-Disposition: #{content_disposition(part)}; filename="#{upload.filename}"),
        %(Content-Type: #{upload.content_type}),
        'Content-Transfer-Encoding: base64',
        '',
        Base64.strict_encode64(upload.contents),
        %(--#{boundary})
      ]
    end

    def boundary
      @boundary ||= "----WorkAPI-Boundary-#{SecureRandom.hex(8)}"
    end

    def model_serializer_class
      JsonapiSerializer
    end

    def serialized_model
      @serialized_model ||= model_serializer_class.new(@body).serialize
    end

    def subsequent_parts
      raise NotImplementedError, "please specificy a +subsequent_parts+ when extending #{self.class.name}"
    end
  end
end
