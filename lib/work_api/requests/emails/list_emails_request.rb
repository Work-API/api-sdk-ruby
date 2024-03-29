# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Emails
      VALID_PARAMS = %i[ids mailbox_ids limit date_from date_until search_text].freeze

      class ListEmailsRequest < BaseRequest[:get, 'email/emails', VALID_PARAMS]; end
    end
  end
end
