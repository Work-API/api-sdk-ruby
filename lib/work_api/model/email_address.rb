# frozen_string_literal: true

require 'work_api/protobufs/model/email_pb'
require_relative 'base_model'

module WorkApi
  EmailAddress = Protobufs::Model::EmailAddress

  class EmailAddress
    include BaseModel
  end
end
