# frozen_string_literal: true

require_relative './common'
require 'byebug'

def create_user
  user_id = ENV['USER_ID'] || "test#{(rand * 10_000_000).to_i}@work-api.com"

  response = Faraday.post(
    "#{LivilApi::Client.url}/users",
    { data: { attributes: { environment_guid: environment_guid, arbitrary_id: user_id } } }.to_json,
    'Accept' => 'application/vnd.api+json',
    'Content-Type' => 'application/vnd.api+json',
    'Authorization' => "Bearer #{generate_apt}"
  )

  raise "Error creating user: #{response.status}" unless response.status < 299

  response.body
end

def load_user
  @load_user ||= begin
                   user_json = File.read(File.expand_path('tmp/user.json', APP_ROOT))
                   LivilApi::Client::Deserializer.new(user_json).deserialize
                 end
end

def reauth_user
  response = Faraday.post(
    "#{LivilApi::Client.url}/users/reauth",
    { data: { attributes: { environment_guid: environment_guid, arbitrary_id: load_user.arbitrary_id } } }.to_json,
    'Accept' => 'application/vnd.api+json',
    'Content-Type' => 'application/vnd.api+json',
    'Authorization' => "Bearer #{generate_apt(arbitrary_id: load_user.arbitrary_id)}"
  )
  
  raise "Error reauthing user: #{response.status}" unless response.status < 299

  response.body
end

namespace :user do
  desc 'Create test user'
  task :create do
    user_json = create_user

    File.open(File.expand_path('tmp/user.json', APP_ROOT), 'wx') do |f|
      f.write(user_json)
    end

    puts 'User created and saved to tmp/user.json'

    Rake::Task['user:print'].invoke
  end

  desc 'Print test user info'
  task :print do
    puts load_user.inspect
  end

  desc 'Refresh the stored token for the test user'
  task :reauth do
    user_json = reauth_user

    File.open(File.expand_path('tmp/user.json', APP_ROOT), 'w') do |f|
      f.write(user_json)
    end

    puts 'User reauth\'d and saved to tmp/user.json'

    Rake::Task['user:print'].invoke
  end
end
