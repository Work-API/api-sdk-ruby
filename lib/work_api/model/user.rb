# frozen_string_literal: true

require 'livil/model/user_pb'
require_relative 'base_model'

module WorkApi
  User = Livil::Model::User

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
