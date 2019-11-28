# frozen_string_literal: true

# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: model/user.proto

require 'google/protobuf'

require_relative './integration_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file('model/user.proto', syntax: :proto3) do
    add_message 'livil.model.User' do
      optional :id, :string, 1
      optional :arbitrary_id, :string, 2
      optional :created_at, :uint64, 4
      optional :token, :string, 5
      repeated :integrations, :message, 6, 'livil.model.Integration'
      optional :environment_guid, :string, 7
    end
  end
end

module Livil
  module Model
    User = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.User').msgclass
  end
end
