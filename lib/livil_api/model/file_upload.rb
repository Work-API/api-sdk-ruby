# frozen_string_literal: true

require 'mimemagic'
require 'mimemagic/overlay'

module LivilApi
  class FileUpload
    DEFAULT_CONTENT_TYPE = 'application/octet-stream'

    attr_reader :filename

    def initialize(filename, io)
      @filename = filename
      @io = io
    end

    def contents
      @io.rewind
      @io.read
    end

    def content_type
      discovered = MimeMagic.by_magic(@io)
      discovered.present? ? discovered : DEFAULT_CONTENT_TYPE
    end
  end
end
