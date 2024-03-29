# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Emails
      class CreateDraftRequest < BaseRequest[:post, 'email/drafts']; end
    end
  end
end
