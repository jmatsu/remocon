# frozen_string_literal: true

module Remocon
  module ConditionSorter
    CONDITION_KEYS = %i[name expression tagColor]

    def sort_conditions(conditions)
      conditions
        .sort_by { |e| e[:name] }
        .map do |e|
        e.sort { |(a, _), (b, _)| CONDITION_KEYS.index(a) <=> CONDITION_KEYS.index(b) }
         .each_with_object({}) { |(k, v), h| h[k] = v }
         .with_indifferent_access
      end
    end
  end
end
