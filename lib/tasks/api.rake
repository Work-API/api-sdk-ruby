# frozen_string_literal: true

require 'pry'
require_relative './common'

namespace :api do
  task :console do
    @client = LivilApi::Service.new(load_user.token)
    puts 'LivilApi::Service instantiated as: @client'
    Pry.start
  end
end
