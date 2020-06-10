# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'livil'))

require 'active_support/core_ext/hash'

require 'work_api/version'
require 'work_api/error'
require 'work_api/remote_error'
require 'work_api/validation_error'

require 'work_api/client'
require 'work_api/service'
require 'work_api/configuration'

require 'work_api/serializers/jsonapi_serializer'
require 'work_api/serializers/multipart_serializer'
require 'work_api/serializers/with_attachment_serializer'
require 'work_api/deserializers/jsonapi_deserializer'

require 'work_api/model/serializable'
require 'work_api/model/user'
require 'work_api/model/integration'
require 'work_api/model/calendar'
require 'work_api/model/event'
require 'work_api/model/event_attendee'
require 'work_api/model/mailbox'
require 'work_api/model/email'
require 'work_api/model/email_attachment'
require 'work_api/model/file'
require 'work_api/model/file_upload'

require 'work_api/requests/base_request'
require 'work_api/requests/apt_request'

require 'work_api/requests/users/create_user_request'
require 'work_api/requests/users/get_user_request'
require 'work_api/requests/users/reauth_user_request'
require 'work_api/requests/users/delete_user_request'

require 'work_api/requests/integrations/list_integrations_request'
require 'work_api/requests/integrations/create_integration_request'
require 'work_api/requests/integrations/modify_integration_request'
require 'work_api/requests/integrations/auth_integration_request'
require 'work_api/requests/integrations/destroy_integration_request'

require 'work_api/requests/events/list_calendars_request'
require 'work_api/requests/events/list_events_request'
require 'work_api/requests/events/get_event_request'
require 'work_api/requests/events/create_event_request'
require 'work_api/requests/events/modify_event_request'
require 'work_api/requests/events/destroy_event_request'

require 'work_api/requests/emails/list_mailboxes_request'
require 'work_api/requests/emails/list_emails_request'
require 'work_api/requests/emails/send_email_request'
require 'work_api/requests/emails/get_email_request'
require 'work_api/requests/emails/trash_emails_request'
require 'work_api/requests/emails/create_draft_request'
require 'work_api/requests/emails/update_draft_request'

module WorkApi
  class APIError < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
