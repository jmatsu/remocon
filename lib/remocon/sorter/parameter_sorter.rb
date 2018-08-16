# frozen_string_literal: true

module Remocon
  module ParameterSorter
    PARAMETER_KEYS = %w(description value file normalizer conditions options).freeze

    def comparator_of_parameter_keys(left, right)
      PARAMETER_KEYS.index(left) <=> PARAMETER_KEYS.index(right)
    end

    def sort_parameters(parameters)
      params = parameters.with_indifferent_access

      params.keys.sort.each_with_object({}) do |key, acc|
        param = params[key]

        acc[key] = param
                       .stringify_keys
                       .sort { |(a, _), (b, _)| comparator_of_parameter_keys(a, b) }
                       .each_with_object({}) do |(inside_key, _), inside_acc|
          if inside_key == "conditions"
            inside_acc[inside_key] = sort_conditions(param[inside_key])
          else
            inside_acc[inside_key] = param[inside_key]
          end
                       end
      end.with_indifferent_access
    end

    def sort_conditions(conditions)
      conditions.with_indifferent_access.to_a.each_with_object({}) do |(k, v), acc|
        acc[k] = v.stringify_keys
                     .sort { |(a, _), (b, _)| comparator_of_parameter_keys(a, b) }
                     .each_with_object({}) do |(inside_key, _), inside_acc|
          inside_acc[inside_key] = v[inside_key]
        end
      end
    end
  end
end
