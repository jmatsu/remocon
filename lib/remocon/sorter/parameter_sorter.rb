# frozen_string_literal: true

module Remocon
  module ParameterSorter
    PARAMETER_KEYS = %i(description value file normalizer conditions options).freeze

    def sort_parameters(parameters)
      arr = parameters.sort.map do |k, v|
        hash_arr = v.sort { |(a, _), (b, _)| PARAMETER_KEYS.index(a) <=> PARAMETER_KEYS.index(b) }
          .map do |k, v|
          {
            k => k.to_sym == :conditions ? sort_parameters(v) : v
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
