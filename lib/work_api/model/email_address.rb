# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'

module WorkApi
  EmailAddress = Livil::Model::EmailAddress

  class EmailAddress
    include BaseModel
  end
end