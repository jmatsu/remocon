# frozen_string_literal: true

module Remocon
  class ConditionFileDumper
    def initialize(conditions)
      @conditions = conditions
    end

    def dump
      # use as it is
      @conditions
    end
  end
end
