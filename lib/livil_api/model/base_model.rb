# frozen_string_literal: true

module LivilApi
  module BaseModel
    def self.included(base)
      base.class_eval do
        alias_method :pb_to_hash, :to_hash
        alias_method :attributes_hash, :to_hash
      end
    end

    def new?
      id.blank?
    end
  end
end
