# frozen_string_literal: true

require_relative './common'

def integration_exists?(provider, media_type)
  load_integration(provider, media_type)
end

def path_for_integration(provider, media_type)
  "integration-#{media_type}-#{provider}"
end

def load_integration(provider, media_type)
  json = read_from_file(path_for_integration(provider, media_type))
  LivilApi::JsonapiDeserializer.new(json).deserialize
rescue Errno::ENOENT
  false
end

def create_integration(provider, media_type)
  path = path_for_integration(provider, media_type)
  raise "Integration already exists: tmp/#{path}.json" if integration_exists?(provider, media_type)

  integration_attrs = { provider: provider, media_type: media_type }

  response = perform_request(:post, 'integrations', payload_attrs: integration_attrs)
  write_to_file(path, response)
  puts "Integration created and saved to #{path}"
end

def auth_integration(provider, media_type)
  integration = load_integration(provider, media_type)
  raise "Integration does not exist or file has been removed: tmp/#{path}.json" unless integration.present?

  path = "auth/init/#{integration.id}"
  response = perform_request(:get, path, query: { redirect: false })

  deserialized = LivilApi::JsonDeserializer.new(response).deserialize

  puts 'Attempting to open a browser window with the following URI:'
  puts deserialized['uri']
  `open "#{deserialized['uri']}"`
end

namespace :integration do
  desc 'Create an integration'
  task :create, [:provider, :media_type] do |_task, args|
    create_integration(args[:provider], args[:media_type])
  end

  desc 'Trigger auth process for an integration'
  task :auth, [:provider, :media_type] do |_task, args|
    auth_integration(args[:provider], args[:media_type])
  end
end
