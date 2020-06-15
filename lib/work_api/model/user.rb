# frozen_string_literal: true

require 'work_api/protobufs/model/user_pb'
require_relative 'base_model'

module WorkApi
  User = Protobufs::Model::User

  class User
    include BaseModel

    CREATE_PARAMS = %i[arbitrary_id environment_guid].freeze

    def id
      pb_to_hash[:id]
    end

    def attributes_hash
      pb_to_hash.slice(*CREATE_PARAMS)
    end
  end
end
