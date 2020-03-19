# frozen_string_literal: true

module LivilApi
  class Service
    module Users
      # Creates a user record on the API
      #
      # Uses the passed in private key to create a short-lived APT to create the user
      #
      # @param [LivilApi::User] user: the user must contain the <tt>arbitrary_id</tt> and <tt>environment_guid</tt>
      # @param [String] path_to_private_key: The local path to the environment's private key file
      #
      # @raise [RemoteError]
      #
      # @return [LivilApi::User] the user parsed from the API's response. **It is possible this won't match the input <tt>user</tt>**
      def create_user(user:, path_to_private_key:)
        request = Requests::Users::CreateUserRequest.new(body: user, path_to_private_key: path_to_private_key)
        call(request).body
      end

      # Get the current user from the API
      #
      # @return [LivilApi::User]
      def get_user # rubocop:disable Naming/AccessorMethodName
        request = Requests::Users::GetUserRequest.new
        call(request).body
      end

      # Reauth a User with an expired token using an APT
      #
      # Uses the passed in private key to create a short-lived APT to create the user
      #
      # @param [LivilApi::User] user: the user must contain the <tt>arbitrary_id</tt> and <tt>environment_guid</tt>
      # @param [String] path_to_private_key: The local path to the environment's private key file
      #
      # @return [LivilApi::User]
      def reauth_user(user:, path_to_private_key:)
        request = Requests::Users::ReauthUserRequest.new(body: user, path_to_private_key: path_to_private_key)
        call(request).body
      end

      # Delete the current user
      #
      # @return [Symbol, :no_content]
      def delete_user
        request = Requests::Users::DeleteUserRequest.new
        call(request).body
      end
    end
  end
end
