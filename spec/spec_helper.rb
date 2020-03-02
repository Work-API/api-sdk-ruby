# frozen_string_literal: true

require 'bundler/setup'
require 'byebug'
require 'ffaker'
require 'livil_api'

APP_ROOT = File.expand_path('..', __dir__)

Dir['./spec/support/*.rb'].sort.each { |r| require r }
Dir['./spec/support/shared_contexts/*.rb'].sort.each { |r| require r }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run(focus: true) if ENV['FOCUS']
end
