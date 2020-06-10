# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'
require_relative 'with_composite_id'
require_relative 'buffable'

module WorkApi
  EmailAttachment = Livil::Model::EmailAttachment

  class EmailAttachment
    include BaseModel
    include WithCompositeId
    include Buffable

    attr_reader :upload

    def attach(filename, io)
      @upload = FileUpload.new(filename, io)
    end
  end
end
