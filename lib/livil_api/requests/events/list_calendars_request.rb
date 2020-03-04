# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      class ListCalendarsRequest < BaseRequest[:get, 'event/calendars']; end
    end
  end
end
