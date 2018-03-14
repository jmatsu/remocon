# frozen_string_literal: true

module Remocon
  class ConditionFileInterpreter
    SUPPORTED_ATTRIBUTED = %i[name expression tagColor]

    def initialize(filepath)
      # conditions should be Array
      @yaml = YAML.safe_load(File.open(filepath).read).map(&:with_indifferent_access)
    end

    def read(opts = {})
      errors = []
      json_array = @yaml.clone

      keys = []

      @yaml.each do |hash|
        raise Remocon::ValidationError, "#{hash[:name]} is duplicated" if keys.include?(hash[:name])
        raise Remocon::ValidationError, 'expression must not be empty' unless hash[:expression]

        keys.push(hash[:name])
      rescue Remocon::ValidationError => e
        raise e unless opts[:validate_only]
        errors.push(e)
      end

      [json_array, errors]
    end
  end
end
