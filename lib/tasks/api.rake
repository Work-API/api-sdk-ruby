# frozen_string_literal: true

require 'pry'
require_relative './common'

namespace :api do
  task :console do
    @client = WorkApi::Service.new(load_user.token)
    puts 'WorkApi::Service instantiated as: @client'
    Pry.start
  end
end
