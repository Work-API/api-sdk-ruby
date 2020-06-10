# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Users
      class DeleteUserRequest < BaseRequest[:delete, 'users/me']; end
    end
  end
end
