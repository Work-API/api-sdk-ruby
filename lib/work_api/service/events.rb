# frozen_string_literal: true

module WorkApi
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

      def get_event(event_id:, calendar_id: nil)
        request = Requests::Events::GetEventRequest.new(event_id: event_id, calendar_id: calendar_id)

        call(request).body
      end

      def list_events(calendar_ids: nil, date_from: nil, date_until: nil, search_text: nil, recurring_event_id: nil, limit: nil)
        params = {}
        params[:calendar_ids] = calendar_ids unless calendar_ids.blank?
        params[:date_from] = date_from unless date_from.nil?
        params[:date_until] = date_until unless date_until.nil?
        params[:search_text] = search_text unless search_text.nil?
        params[:limit] = limit unless limit.nil?
        params[:recurring_event_id] = recurring_event_id unless recurring_event_id.nil?

        request = Requests::Events::ListEventsRequest.new(params)

        call(request).body
      end

      def destroy_event(event_id:, calendar_id: nil)
        params = { event_id: event_id }
        params[:calendar_id] = calendar_id if calendar_id.present?
        request = Requests::Events::DestroyEventRequest.new(**params)

        call(request).body
      end
    end
  end
end
