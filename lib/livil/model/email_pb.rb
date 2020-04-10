# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: model/email.proto

require 'google/protobuf'

require 'google/protobuf/any_pb'
require 'model/file_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("model/email.proto", :syntax => :proto3) do
    add_message "livil.model.Mailbox" do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
      optional :name, :string, 3
      optional :unread_count, :uint64, 4
      optional :total_count, :uint64, 5
    end
    add_message "livil.model.Conversation" do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
    end
    add_message "livil.model.Email" do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
      optional :thread_id, :string, 3
      optional :subject, :string, 4
      optional :body, :message, 5, "livil.model.EmailBody"
      optional :sender, :message, 6, "livil.model.EmailAddress"
      repeated :to_recipients, :message, 7, "livil.model.EmailAddress"
      repeated :cc_recipients, :message, 8, "livil.model.EmailAddress"
      repeated :bcc_recipients, :message, 9, "livil.model.EmailAddress"
      optional :flags, :message, 10, "livil.model.EmailFlags"
      repeated :labels, :string, 11
      repeated :mailboxes, :message, 12, "livil.model.Mailbox"
      repeated :attachments, :message, 13, "livil.model.EmailAttachment"
      optional :has_attachments, :bool, 14
      optional :received_at, :uint64, 15
    end
    add_message "livil.model.EmailBody" do
      repeated :plain_text, :string, 1
      repeated :html, :string, 2
    end
    add_message "livil.model.EmailAddress" do
      optional :name, :string, 1
      optional :address, :string, 2
    end
    add_message "livil.model.EmailFlags" do
      optional :seen, :bool, 1
      optional :flagged, :bool, 2
    end
    add_message "livil.model.EmailAttachment" do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
      optional :inline, :bool, 3
      optional :payload, :message, 4, "google.protobuf.Any"
      optional :content_transfer_encoding, :string, 5
      optional :filename, :string, 6
      optional :mime_type, :string, 7
      optional :size, :uint64, 8
      optional :uri, :string, 9
    end
  end
end

module Livil
  module Model
    Mailbox = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.Mailbox").msgclass
    Conversation = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.Conversation").msgclass
    Email = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.Email").msgclass
    EmailBody = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.EmailBody").msgclass
    EmailAddress = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.EmailAddress").msgclass
    EmailFlags = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.EmailFlags").msgclass
    EmailAttachment = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.EmailAttachment").msgclass
  end
end
