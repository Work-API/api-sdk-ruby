# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.default_cassette_options = {
    match_requests_on: %i[method uri body]
  }
  config.cassette_library_dir = './spec/support/cassettes'
  config.hook_into :webmock
end
