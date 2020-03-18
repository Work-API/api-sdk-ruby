# frozen_string_literal: true

module LivilApi
  class Service
    module Users
      def create_user(user:, path_to_private_key:)
        request = Requests::Users::CreateUserRequest.new(body: user, path_to_private_key: path_to_private_key)
        call(request).body
      end

      def refresh_user_token(environment_guid:, arbitrary_id:, path_to_private_key:)
        # TODO
      end
    end
  end
end
