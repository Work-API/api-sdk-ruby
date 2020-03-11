# frozen_string_literal: true

require_relative './multipart_serializer'
require 'securerandom'

module LivilApi
  class WithAttachmentSerializer < MultipartSerializer
    def model_type
      'email'
    end

    def subsequent_parts_type
      'files[]'
    end

    def subsequent_parts
      @body.attachments
    end

    def content_disposition(model)
      case model
      when EmailAttachment
        %(form-data; name="#{subsequent_parts_type}")
      else
        super
      end
    end
  end
end
