# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: model/subscription.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("model/subscription.proto", :syntax => :proto3) do
    add_message "livil.model.Subscription" do
      optional :remote_id, :string, 1
      optional :expiry_time, :uint64, 2
      optional :sync_token, :string, 3
    end
  end
end

module Livil
  module Model
    Subscription = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livil.model.Subscription").msgclass
  end
end
