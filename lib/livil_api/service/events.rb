# frozen_string_literal: true

module LivilApi
  class Service
    module Events
      def list_calendars
        request = Requests::Events::ListCalendarsRequest.new

        call(request).body
      end

      def create_event(event:)
        request = Requests::Events::CreateEventRequest.new(body: event)

        call(request).body
      end

      def modify_event(event_id:, event:)
        request = Requests::Events::ModifyEventRequest.new(event_id: event_id, body: event)

        call(request).body
      end

      def list_events(date_from: nil, date_until: nil, search_text: nil)
        params = {}
        params[:date_from] = date_from unless date_from.nil?
        params[:date_until] = date_until unless date_until.nil?
        params[:search_text] = search_text unless search_text.nil?

        request = Requests::Events::ListEventsRequest.new(params)

        call(request).body
      end

      def destroy_event(event_id:)
        request = Requests::Events::DestroyEventRequest.new(event_id: event_id)

        call(request).body
      end
    end
  end
end
