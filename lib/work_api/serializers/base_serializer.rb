# frozen_string_literal: true

module WorkApi
  class BaseSerializer
    def initialize(body)
      @body = body
    end

    def content_type
      raise NotImplementedError, 'you must define a +content_type+ for a serializer'
    end

    def serialize
      raise NotImplementedError
    end

    def content_disposition(model)
      %(form-data; name="#{class_name_for(model)}")
    end

    def class_name_for(model)
      model.class.name.split('::').last.underscore
    end
  end
end
