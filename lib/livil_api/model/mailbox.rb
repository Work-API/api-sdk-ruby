# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module LivilApi
  Mailbox = Livil::Model::Mailbox

  class Mailbox
    include BaseModel
    include WithCompositeId
  end
end
