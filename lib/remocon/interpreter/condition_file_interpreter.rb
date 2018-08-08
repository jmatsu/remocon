# frozen_string_literal: true

module Remocon
  class ConditionFileInterpreter
    SUPPORTED_ATTRIBUTED = %i(name expression tagColor).freeze

    def initialize(filepath)
      # conditions should be Array
      @yaml = YAML.safe_load(File.open(filepath).read).map(&:with_indifferent_access)
    end

    def read(opts = {})
      errors = []
      json_array = @yaml.dup

      keys = []

      @yaml.each do |hash|
        begin
          raise Remocon::EmptyNameError, "name must not be empty" unless hash[:name]
          raise Remocon::EmptyExpressionError, "expression must not be empty" unless hash[:expression]
          raise Remocon::DuplicateKeyError, "#{hash[:name]} is duplicated" if keys.include?(hash[:name])

          keys.push(hash[:name])
        rescue Remocon::ValidationError => e
          raise e unless opts[:validate_only]
          errors.push(e)
        end
      end

      [json_array, errors]
    end
  end
end
