# frozen_string_literal: true

module LivilApi
  class Service
    module ErrorHandling
      def handle_errors(request, response)
        raise RemoteError, "#{request.class.name} resulted in a #{response.http_code} " \
          "error with the following reason(s): \n#{error_summary(response.errors)}"
      end

      def error_summary(errors)
        errors.map do |error|
          "#{error.code}: #{error.message}"
        end.join("\n")
      end
    end
  end
end
