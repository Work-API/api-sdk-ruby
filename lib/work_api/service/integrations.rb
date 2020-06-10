# frozen_string_literal: true

module WorkApi
  class Service
    module Integrations
      def create_integration(integration:)
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

      def modify_integration(integration:)
        request = Requests::Integrations::ModifyIntegrationRequest.new(integration_id: integration.id, body: integration)

        call(request).body
      end

      def destroy_integration(integration_id:)
        request = Requests::Integrations::DestroyIntegrationRequest.new(integration_id: integration_id)

        call(request)
      end
    end
  end
end
