# frozen_string_literal: true

require 'work_api/protobufs/model/event_pb'
require_relative 'base_model'

module WorkApi
  EventAttendee = Protobufs::Model::EventAttendee

  class EventAttendee
    include BaseModel

    attribute :response_status, default: 'needsAction'
  end
end
