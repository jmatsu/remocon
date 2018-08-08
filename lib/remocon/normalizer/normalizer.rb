# frozen_string_literal: true

module Remocon
  class Normalizer
    attr_reader :content

    def initialize(content, opts)
      @content = content.nil? ? opts[:default] : content
      @opts = opts
    end

    def process
      tap do
        raise Remocon::ValidationError, "#{self.class} is not satisfying normalizer" unless self.class.respond_symbol

        validate
        @content = normalize
      end
    end

    def validate
      # no-op
    end

    def normalize
      @content
    end

    def self.respond_symbol
      raise Remocon::UnsupportedTypeError, "unknown"
    end
  end
end
