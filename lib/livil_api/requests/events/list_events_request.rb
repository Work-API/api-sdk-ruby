# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      VALID_PARAMS = %i[calendar_ids date_from date_until recurring_event_id search_text limit].freeze

      class ListEventsRequest < BaseRequest[:get, 'event/events', VALID_PARAMS]
        def validate
          validate_recurrence_params
        end

        private

        def validate_recurrence_params
          @errors[:recurring_event_id] = 'must be combined with a single item in "calendar_ids"' \
            if @params[:recurring_event_id].present? && @params[:calendar_ids]&.count != 1
        end
      end
    end
  end
end
