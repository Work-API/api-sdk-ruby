# frozen_string_literal: true

module WorkApi
  class Service
    module Emails
      def list_mailboxes
        request = Requests::Emails::ListMailboxesRequest.new

        call(request).body
      end

      def send_email(email:)
        request = Requests::Emails::SendEmailRequest.new(body: email)

        call(request).body
      end

      # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength
      def list_emails(email_ids: nil, mailbox_ids: nil, limit: nil, page: nil, date_from: nil, date_until: nil, search_text: nil, contact: nil)
        params = {}
        params[:email_ids] = email_ids unless email_ids.nil?
        params[:mailbox_ids] = mailbox_ids unless mailbox_ids.nil?
        params[:limit] = limit unless limit.nil?
        params[:page] = page unless page.nil?
        params[:date_from] = date_from unless date_from.nil?
        params[:date_until] = date_until unless date_until.nil?
        params[:search_text] = search_text unless search_text.nil?
        params[:contact] = contact unless contact.nil?

        request = Requests::Emails::ListEmailsRequest.new(params)

        call(request).body
      end
      # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength

      def get_email(email_id:)
        request = Requests::Emails::GetEmailRequest.new(email_id: email_id)

        call(request).body
      end

      def trash_emails(ids:)
        request = Requests::Emails::TrashEmailsRequest.new(ids: ids)

        call(request).body
      end

      def create_draft(email:)
        request = Requests::Emails::CreateDraftRequest.new(body: email)

        call(request).body
      end

      def update_draft(email_id:, email:)
        request = Requests::Emails::UpdateDraftRequest.new(body: email, email_id: email_id)

        call(request).body
      end
    end
  end
end
