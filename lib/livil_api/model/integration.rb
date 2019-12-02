# frozen_string_literal: true

require 'livil/model/integration_pb'
require_relative 'base_model'

module LivilApi
  Integration = Livil::Model::Integration

  class Integration
    include BaseModel

    CREATE_PARAMS = %i[provider media_type].freeze

    def attributes_hash
      pb_to_hash.slice(*CREATE_PARAMS)
    end
  end
end
