# frozen_string_literal: true

module Remocon
  module ParameterSorter
    PARAMETER_KEYS = %i(description value file normalizer conditions options).freeze

    def sort_parameters(parameters)
      arr = parameters.sort.map do |k, v|
        hash_arr = v.symbolize_keys.sort { |(a, _), (b, _)| PARAMETER_KEYS.index(a) <=> PARAMETER_KEYS.index(b) }
          .map do |k1, v1|
          {
            k1 => k1.to_sym == :conditions ? sort_conditions(v1) : v1
          }
        end

        {
          k => hash_arr.each_with_object({}) { |hash, acc| acc.merge!(hash) }
        }
      end

      arr.each_with_object({}) { |hash, acc| acc.merge!(hash) }.with_indifferent_access
    end

    def sort_conditions(conditions)
      arr = conditions.map do |k, v|
        hash_arr = v.symbolize_keys.sort { |(a, _), (b, _)| PARAMETER_KEYS.index(a) <=> PARAMETER_KEYS.index(b) }
                       .map do |k1, v1|
          {
              k1 => v1
          }
        end

        {
            k => hash_arr.each_with_object({}) { |hash, acc| acc.merge!(hash) }
        }
      end

      arr.each_with_object({}) { |hash, acc| acc.merge!(hash) }.with_indifferent_access
    end
  end
end
