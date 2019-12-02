# frozen_string_literal: true

module LivilApi
  class Service
    def initialize(token = nil)
      @token = token
    end

    def create_user(environment_guid:, arbitrary_id:, path_to_private_key:)
      user = User.new(arbitrary_id: arbitrary_id, environment_guid: environment_guid)
      request = Requests::Users::CreateUserRequest.new(body: user, path_to_private_key: path_to_private_key)
      call(request)
    end

    def refresh_user_token(environment_guid:, arbitrary_id:, path_to_private_key:)
      # TODO
    end

    def create_integration(provider:, media_type:)
      integration = Integration.new(
        provider: provider,
        media_type: media_type
      )

      request = Requests::Integrations::CreateIntegrationRequest.new(body: integration)

      call(request).body
    end

    def auth_integration(integration_id:, return_to:)
      request = Requests::Integrations::AuthIntegrationRequest.new(
        integration_id: integration_id,
        return_to: return_to
      )

      call(request)
    end

    def list_integrations
      call(Requests::Integrations::ListIntegrationsRequest.new)
    end

    def destroy_integration(integration_id:)
      call(Requests::Integrations::DestroyIntegrationRequest.new(integration_id: integration_id))
    end

    def list_events
      call(Requests::Events::ListEventsRequest.new)
    end

    protected

    def call(request)
      client.call(request, token: @token)
    end

    def client
      @client ||= Client.new
    end
  end
end