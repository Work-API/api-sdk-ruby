# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'livil_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'work_api'
  spec.version       = WorkApi::VERSION
  spec.authors       = ['Dan de Havilland']
  spec.email         = ['dan@livil.co']

  spec.summary       = 'SDK for accessing Work-API REST backend'
  spec.homepage      = 'https://github.com/Work-API/api-sdk-ruby'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "#{spec.homepage}.git"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 6'
  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_dependency 'google-protobuf', '3.7.0'
  spec.add_dependency 'jwt', '~> 2.2'
  spec.add_dependency 'mimemagic', '~> 0.4.3'
  spec.add_dependency 'uuidtools', '~> 2.1'

  # spec.add_development_dependency 'bundler', '~> 2.0'
  # spec.add_development_dependency 'ffaker', '~> 2.1'
  # spec.add_development_dependency 'guard', '~> 2.1'
  # spec.add_development_dependency 'guard-rspec', '~> 4.7'
  # spec.add_development_dependency 'guard-rubocop', '~> 1.3'
  # spec.add_development_dependency 'rake', '~> 10.0'
  # spec.add_development_dependency 'rspec', '~> 3.0'
  # spec.add_development_dependency 'rubocop', '~> 0.76'
  # spec.add_development_dependency 'vcr', '~> 5'
  # spec.add_development_dependency 'webmock', '~> 3.7'
end
