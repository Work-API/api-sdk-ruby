# frozen_string_literal: true

require_relative './common'
require 'byebug'

def create_user
  user_id = ENV['USER_ID'] || "test#{(rand * 10_000_000).to_i}@work-api.com"

  perform_request(
    :post,
    'users',
    payload_attrs: { environment_guid: environment_guid, arbitrary_id: user_id },
    token: generate_apt
  )
end

def reauth_user
  user_id = ENV['USER_ID'] || load_user.arbitrary_id

  perform_request(
    :post,
    'users/reauth',
    payload_attrs: { environment_guid: environment_guid, arbitrary_id: user_id },
    token: generate_apt(arbitrary_id: user_id)
  )
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
