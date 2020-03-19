# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      VALID_PARAMS = %i[date_from date_until recurring_event_id search_text].freeze

      class ListEventsRequest < BaseRequest[:get, 'event/events', VALID_PARAMS]; end
    end
  end
end
