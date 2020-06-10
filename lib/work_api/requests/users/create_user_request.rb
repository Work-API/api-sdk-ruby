# frozen_string_literal: true

require_relative '../apt_request'

module WorkApi
  module Requests
    module Users
      class CreateUserRequest < AptRequest[:post, 'users', %i[path_to_private_key]]; end
    end
  end
end
