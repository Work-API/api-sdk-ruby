# frozen_string_literal: true

module LivilApi
  class Service
    module Emails
      def list_mailboxes
        request = Requests::Emails::ListMailboxesRequest.new

        call(request).body
      end

      # def create_event(event:)
      #   request = Requests::Events::CreateEventRequest.new(body: event)

      #   call(request).body
      # end

      # def modify_event(event_id:, event:)
      #   request = Requests::Events::ModifyEventRequest.new(event_id: event_id, body: event)

      #   call(request).body
      # end

      def list_emails(email_ids: nil, mailbox_ids: nil, limit: nil, date_from: nil, date_until: nil, search_text: nil)
        params = {}
        params[:email_ids] = email_ids unless email_ids.nil?
        params[:mailbox_ids] = mailbox_ids unless mailbox_ids.nil?
        params[:limit] = limit unless limit.nil?
        params[:date_from] = date_from unless date_from.nil?
        params[:date_until] = date_until unless date_until.nil?
        params[:search_text] = search_text unless search_text.nil?

        request = Requests::Emails::ListEmailsRequest.new(params)

        call(request).body
      end

      # def destroy_event(event_id:)
      #   request = Requests::Events::DestroyEventRequest.new(event_id: event_id)

      #   call(request).body
      # end
    end
  end
end
