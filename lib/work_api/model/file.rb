# frozen_string_literal: true

require 'livil/model/file_pb'
require_relative 'base_model'
require_relative 'with_composite_id'

module WorkApi
  File = Livil::Model::File

  class File
    include BaseModel
    include WithCompositeId
  end
end
