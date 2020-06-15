# frozen_string_literal: true

require 'work_api/protobufs/model/email_pb'
require_relative 'base_model'

module WorkApi
  EmailBody = Protobufs::Model::EmailBody

  class EmailBody
    include BaseModel
  end
end
