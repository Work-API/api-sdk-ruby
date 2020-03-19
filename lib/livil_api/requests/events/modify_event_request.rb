# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      class ModifyEventRequest < BaseRequest[:put, 'event/events/{event_id}', %i[event_id]]; end
    end
  end
end
