# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Emails
      class ListMailboxesRequest < BaseRequest[:get, 'email/mailboxes']; end
    end
  end
end
