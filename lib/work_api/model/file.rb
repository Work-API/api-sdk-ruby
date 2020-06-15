# frozen_string_literal: true

require 'work_api/protobufs/model/file_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module WorkApi
  File = Protobufs::Model::File

  class File
    include BaseModel
    include WithCompositeId
  end
end
