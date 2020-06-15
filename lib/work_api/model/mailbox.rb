# frozen_string_literal: true

require 'work_api/protobufs/model/email_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module WorkApi
  Mailbox = Protobufs::Model::Mailbox

  class Mailbox
    include BaseModel
    include WithCompositeId
  end
end
