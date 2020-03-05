# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      class DestroyEventRequest < BaseRequest[:delete, 'event/events/{event_id}']; end
    end
  end
end
