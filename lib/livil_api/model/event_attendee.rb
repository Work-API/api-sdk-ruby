# frozen_string_literal: true

require 'livil/model/event_pb'
require_relative 'base_model'

module LivilApi
  EventAttendee = Livil::Model::EventAttendee

  class EventAttendee
    include BaseModel

    attribute :response_status, default: 'needsAction'
  end
end
