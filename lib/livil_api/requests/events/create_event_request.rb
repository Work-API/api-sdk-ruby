# frozen_string_literal: true

require_relative '../base_request'

module LivilApi
  module Requests
    module Events
      class CreateEventRequest < BaseRequest[:post, 'event/events']; end
    end
  end
end
