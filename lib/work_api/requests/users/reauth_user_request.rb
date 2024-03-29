# frozen_string_literal: true

require_relative '../apt_request'

module WorkApi
  module Requests
    module Users
      class ReauthUserRequest < AptRequest[:post, 'users/reauth', %i[path_to_private_key]]
        def apt_params
          super.merge(arbitrary_id: @body.arbitrary_id)
        end
      end
    end
  end
end
