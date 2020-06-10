# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Events
      class DestroyEventRequest < BaseRequest[:delete, 'event/events/{event_id}', %i[event_id calendar_id]]; end
    end
  end
end
