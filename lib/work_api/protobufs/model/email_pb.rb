# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/model/email.proto

require 'google/protobuf'

require 'google/protobuf/any_pb'
require 'protobufs/model/file_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "work_api.protobufs.model.Mailbox" do
    optional :remote_id, :string, 1
    optional :integration_id, :string, 2
    optional :name, :string, 3
    optional :unread_count, :uint64, 4
    optional :total_count, :uint64, 5
  end
  add_message "work_api.protobufs.model.Conversation" do
    optional :remote_id, :string, 1
    optional :integration_id, :string, 2
  end
  add_message "work_api.protobufs.model.Email" do
    optional :remote_id, :string, 1
    optional :integration_id, :string, 2
    optional :thread_id, :string, 3
    optional :subject, :string, 4
    optional :body, :message, 5, "work_api.protobufs.model.EmailBody"
    optional :sender, :message, 6, "work_api.protobufs.model.EmailAddress"
    repeated :to_recipients, :message, 7, "work_api.protobufs.model.EmailAddress"
    repeated :cc_recipients, :message, 8, "work_api.protobufs.model.EmailAddress"
    repeated :bcc_recipients, :message, 9, "work_api.protobufs.model.EmailAddress"
    optional :flags, :message, 10, "work_api.protobufs.model.EmailFlags"
    repeated :labels, :string, 11
    repeated :mailboxes, :message, 12, "work_api.protobufs.model.Mailbox"
    repeated :attachments, :message, 13, "work_api.protobufs.model.EmailAttachment"
    optional :has_attachments, :bool, 14
    optional :received_at, :uint64, 15
  end
  add_message "work_api.protobufs.model.EmailBody" do
    repeated :plain_text, :string, 1
    repeated :html, :string, 2
  end
  add_message "work_api.protobufs.model.EmailAddress" do
    optional :name, :string, 1
    optional :address, :string, 2
  end
  add_message "work_api.protobufs.model.EmailFlags" do
    optional :seen, :bool, 1
    optional :flagged, :bool, 2
  end
  add_message "work_api.protobufs.model.EmailAttachment" do
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

module WorkApi
  module Protobufs
    module Model
      Mailbox = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.Mailbox").msgclass
      Conversation = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.Conversation").msgclass
      Email = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.Email").msgclass
      EmailBody = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.EmailBody").msgclass
      EmailAddress = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.EmailAddress").msgclass
      EmailFlags = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.EmailFlags").msgclass
      EmailAttachment = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.EmailAttachment").msgclass
    end
  end
end
