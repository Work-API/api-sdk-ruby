# frozen_string_literal: true

require_relative '../base_request'
require_relative '../../apt_generator'

module LivilApi
  module Requests
    module Users
      class CreateUserRequest < BaseRequest[:post, 'users']
        INTERNAL_PARAMS = %i[path_to_private_key].freeze

        def params
          super.except(*INTERNAL_PARAMS)
        end

        def token
          AptGenerator.generate_apt(
            environment_guid: @body.environment_guid,
            path_to_private_key: @params[:path_to_private_key]
          )
        end

        protected

        def validate!
          raise 'no private key path provided' unless @params[:path_to_private_key].present?
          raise 'private key file does not exist' unless File.exist?(@params[:path_to_private_key])
        end
      end
    end
  end
end
