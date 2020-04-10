# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'
require_relative 'with_composite_id'
require_relative 'email_body'
require_relative 'email_address'

module LivilApi
  Email = Livil::Model::Email

  class Email
    include BaseModel
    include WithCompositeId

    serialize_with :remote_id,
                   :integration_id,
                   :subject,
                   :body,
                   :sender,
                   :to_recipients,
                   :cc_recipients,
                   :bcc_recipients,
                   :flags

    def serializer
      @serializer ||= if attachments.present?
                        WithAttachmentSerializer.new(self)
                      else
                        super
                      end
    end

    def email_attachments
      attachments
    end
  end
end
