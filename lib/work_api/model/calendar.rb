# frozen_string_literal: true

require 'work_api/protobufs/model/event_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module WorkApi
  Calendar = Protobufs::Model::Calendar

  class Calendar
    include BaseModel
    include WithCompositeId
  end
end
