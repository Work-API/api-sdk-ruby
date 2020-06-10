# frozen_string_literal: true

require 'livil/model/email_pb'
require_relative 'base_model'

module WorkApi
  EmailBody = Livil::Model::EmailBody

  class EmailBody
    include BaseModel
  end
end
