# frozen_string_literal: true

require_relative '../base_request'

module WorkApi
  module Requests
    module Events
      class CreateEventRequest < BaseRequest[:post, 'event/events']; end
    end
  end
end
