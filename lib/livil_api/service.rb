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
      call(Requests::Integrations::ListIntegrationsRequest.new).body
    end

    def modify_integration(integration_id:, **params)
      integration = Integration.new(id: integration_id, **params)
      request = Requests::Integrations::ModifyIntegrationRequest.new(integration_id: integration_id, body: integration)

      call(request).body
    end

    def destroy_integration(integration_id:)
      request = Requests::Integrations::DestroyIntegrationRequest.new(integration_id: integration_id)

      call(request)
    end

    def list_calendars
      request = Requests::Events::ListCalendarsRequest.new

      call(request).body
    end

    def create_event(event:)
      request = Requests::Events::CreateEventRequest.new(body: event)

      call(request).body
    end

    def list_events(date_from: nil, date_until: nil, search_text: nil)
      params = {}
      params[:date_from] = date_from unless date_from.nil?
      params[:date_until] = date_until unless date_until.nil?
      params[:search_text] = search_text unless search_text.nil?

      request = Requests::Events::ListEventsRequest.new(params)

      call(request).body
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
