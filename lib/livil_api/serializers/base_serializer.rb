# frozen_string_literal: true

module LivilApi
  class BaseSerializer
    def initialize(body)
      @body = body
    end

    def serialize
      raise NotImplementedError
    end
  end
end
