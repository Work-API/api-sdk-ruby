# frozen_string_literal: true

source 'https://rubygems.org'

group :development, :test do
  gem 'byebug'
  gem 'spico-api-base',
      git: "https://#{ENV['GITHUB_TOKEN']}:x-oauth-basic@github.com/livilco/spico-api-base.git",
      branch: 'master',
      # path: '/repos/spico/spico-api-base',
      require: ['spico']
end

# Specify your gem's dependencies in livil_api.gemspec
gemspec
