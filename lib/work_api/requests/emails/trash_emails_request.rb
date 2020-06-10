# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Emails
      class TrashEmailsRequest < BaseRequest[:delete, 'email/emails', %i[ids]]; end
    end
  end
end
