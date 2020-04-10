# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Emails
      class CreateDraftRequest < BaseRequest[:post, 'email/drafts']; end
    end
  end
end
