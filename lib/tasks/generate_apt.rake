# frozen_string_literal: true

require_relative './common'
require 'work_api/apt_generator'
require 'work_api/client'

def load_tokens
  raw_json = File.read(File.expand_path('tmp/tokens.json'))
  JSON.parse(raw_json).with_indifferent_access
rescue Errno::ENOENT
  {}
end

namespace :generate do
  desc 'Generate APT token'
  task :apt do
    tokens = load_tokens
    tokens[:apt] = generate_apt

    File.open(File.expand_path('tmp/tokens.json', APP_ROOT), 'w+') do |f|
      f.write(tokens.to_json)
    end

    puts 'APT generated and appended to tmp/tokens.json'
  end
end
