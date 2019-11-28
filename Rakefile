# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'compile protobufs to ruby classes'
task :compile_protobufs do
  args = ['-I protobufs', 'protobufs/model/*.proto']
  args << '--ruby_out lib/livil'

  cmd = "protoc  #{args.join(' ')}"
  puts 'Compiling protobufs...'
  result = `#{cmd}`
  puts result
end
