# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module LivilApi
  Email = Livil::Model::Email

  class Email
    include BaseModel
    include WithCompositeId
  end
end
