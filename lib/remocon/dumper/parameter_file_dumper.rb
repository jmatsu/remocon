# frozen_string_literal: true

module Remocon
  class ParameterFileDumper
    def initialize(parameters)
      @parameters = parameters.with_indifferent_access
    end

    def dump
      @parameters.each_with_object({}) do |(key, body), hash|
        hash[key] = body[:defaultValue]
        hash[key][:description] = body[:description] if body[:description]

        next unless body[:conditionalValues]

        hash[key][:conditions] = body[:conditionalValues].each_with_object({}) do |(key2, body2), hash2|
          hash2[key2] = body2
        end
      end
    end
  end
end
