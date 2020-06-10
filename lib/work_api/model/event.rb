# frozen_string_literal: true

require 'livil/model/event_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module WorkApi
  Event = Livil::Model::Event

  class Event
    include BaseModel
    include WithCompositeId
  end
end
