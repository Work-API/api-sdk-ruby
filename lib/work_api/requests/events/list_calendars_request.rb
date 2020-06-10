# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Events
      class ListCalendarsRequest < BaseRequest[:get, 'event/calendars']; end
    end
  end
end
