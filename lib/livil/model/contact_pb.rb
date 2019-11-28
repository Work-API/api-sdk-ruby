# frozen_string_literal: true

# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: model/contact.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file('model/contact.proto', syntax: :proto3) do
    add_message 'livil.model.ContactGroup' do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
      optional :name, :string, 3
    end
    add_message 'livil.model.Contact' do
      optional :remote_id, :string, 1
      optional :integration_id, :string, 2
      optional :title, :string, 3
      optional :first_name, :string, 4
      optional :middle_name, :string, 5
      optional :last_name, :string, 6
      repeated :email_addresses, :message, 7, 'livil.model.ContactEmailAddress'
      repeated :phone_numbers, :message, 8, 'livil.model.ContactPhoneNumber'
      repeated :addresses, :message, 9, 'livil.model.ContactAddress'
      repeated :groups, :message, 10, 'livil.model.ContactGroup'
      optional :picture_url, :string, 11
      optional :created_at, :uint64, 12
      optional :updated_at, :uint64, 13
    end
    add_message 'livil.model.ContactEmailAddress' do
      optional :primary, :bool, 1
      optional :type, :string, 2
      optional :address, :string, 3
    end
    add_message 'livil.model.ContactPhoneNumber' do
      optional :primary, :bool, 1
      optional :type, :string, 2
      optional :number, :string, 3
    end
    add_message 'livil.model.ContactAddress' do
      optional :primary, :bool, 1
      optional :type, :string, 2
      optional :street, :string, 3
      optional :city, :string, 4
      optional :region, :string, 5
      optional :postal_code, :string, 6
      optional :country, :string, 7
    end
  end
end

module Livil
  module Model
    ContactGroup = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.ContactGroup').msgclass
    Contact = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.Contact').msgclass
    ContactEmailAddress = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.ContactEmailAddress').msgclass
    ContactPhoneNumber = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.ContactPhoneNumber').msgclass
    ContactAddress = Google::Protobuf::DescriptorPool.generated_pool.lookup('livil.model.ContactAddress').msgclass
  end
end
