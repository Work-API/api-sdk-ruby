# frozen_string_literal: true

require 'livil/model/event_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module LivilApi
  Calendar = Livil::Model::Calendar

  class Calendar
    include BaseModel
    include WithCompositeId
  end
end
