# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'work_api'

APP_ROOT = __dir__

Dir['./lib/tasks/**/*.rake'].each { |r| import r }

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'compile protobufs to ruby classes'
task :compile_protobufs do
  args = ['-I protobufs', 'protobufs/model/*.proto', 'protobufs/error.proto']
  args << '--ruby_out lib/work_api'

  cmd = "protoc  #{args.join(' ')}"
  puts 'Compiling protobufs...'
  result = `#{cmd}`
  puts result
end
