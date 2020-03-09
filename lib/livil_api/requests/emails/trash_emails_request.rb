# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Emails
      class TrashEmailsRequest < BaseRequest[:delete, 'email/emails']; end
    end
  end
end
