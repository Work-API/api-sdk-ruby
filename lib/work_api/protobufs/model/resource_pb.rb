# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/model/resource.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "work_api.protobufs.model.Resource" do
    optional :remote_id, :string, 1
    optional :integration_id, :string, 2
  end
end

module WorkApi
  module Protobufs
    module Model
      Resource = Google::Protobuf::DescriptorPool.generated_pool.lookup("work_api.protobufs.model.Resource").msgclass
    end
  end
end