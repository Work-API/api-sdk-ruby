# frozen_string_literal: true

require 'livil_api/version'
require 'livil_api/client'
require 'livil_api/configuration'
require 'active_support/core_ext/hash'

module LivilApi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
