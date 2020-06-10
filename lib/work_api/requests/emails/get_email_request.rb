# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Emails
      class GetEmailRequest < BaseRequest[:get, 'email/emails/{email_id}', %i[email_id]]; end
    end
  end
end
