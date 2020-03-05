# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Emails
      class TrashEmailRequest < BaseRequest[:delete, 'email/emails/{email_id}']; end
    end
  end
end
