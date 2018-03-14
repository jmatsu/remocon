# frozen_string_literal: true

module Remocon
  class UnsupportedTypeError < StandardError
    def initialize(type)
      super "#{type} is not supported as type"
    end
  end
end
