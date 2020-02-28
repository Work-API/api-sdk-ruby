# frozen_string_literal: true

require 'livil_api/requests/integrations/create_integration_request'
require 'livil_api/requests/integrations/destroy_integration_request'

RSpec.shared_context 'with live integration' do
  include_context 'with live client'

  def create_live_integration
    integration = LivilApi::Integration.new(provider: provider, media_type: media_type)
    request = LivilApi::Requests::Integrations::CreateIntegrationRequest.new(body: integration)
    make_request(request).body
  end

  def destroy_live_integration
    integration = LivilApi::Integration.new(id: integration_id)
    request = LivilApi::Requests::Integrations::DestroyIntegrationRequest.new(integration_id: integration.id)
    make_request(request).body
  end

  let(:provider) { 'gcal' }
  let(:media_type) { 'event' }

  let(:integration) { create_live_integration }
  let(:integration_id) { integration.id }
end
