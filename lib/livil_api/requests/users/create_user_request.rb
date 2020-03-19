# frozen_string_literal: true

require_relative '../apt_request'

module LivilApi
  module Requests
    module Users
      class CreateUserRequest < AptRequest[:post, 'users']; end
    end
  end
end
