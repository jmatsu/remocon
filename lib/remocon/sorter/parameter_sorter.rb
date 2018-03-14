# frozen_string_literal: true

module Remocon
  module ParameterSorter
    PARAMETER_KEYS = %i[description value file normalizer conditions options]

    def sort_parameters(parameters)
      arr = parameters.sort.map do |k, v|
        {
          k => v.sort { |(a, _), (b, _)| PARAMETER_KEYS.index(a) <=> PARAMETER_KEYS.index(b) }
                .map { |k, v| { k => %i[conditions options].include?(k.to_sym) ? sort_parameters(v) : v } }
                .each_with_object({}) { |hash, acc| acc.merge!(hash) }
        }
      end

      arr.each_with_object({}) { |hash, acc| acc.merge!(hash) }.with_indifferent_access
    end
  end
end
