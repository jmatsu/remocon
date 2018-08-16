# frozen_string_literal: true

module Remocon
  module ConditionSorter
    CONDITION_KEYS = %w(name expression tagColor).freeze

    def comparator_of_condition_keys(left, right)
      (CONDITION_KEYS.index(left) || 10_000) <=> (CONDITION_KEYS.index(right) || 10_000)
    end

    def sort_conditions(conditions)
      conditions
        .sort_by { |e| e["name"] || e[:name] }
        .map do |e|
        e.stringify_keys.sort { |(a, _), (b, _)| comparator_of_condition_keys(a, b) }
            .each_with_object({}) do |(k, v), acc|
          acc[k] = v
        end.with_indifferent_access
      end
    end
  end
end
