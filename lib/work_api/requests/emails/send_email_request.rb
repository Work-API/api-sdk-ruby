# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Emails
      class SendEmailRequest < BaseRequest[:post, 'email/emails']; end
    end
  end
end
