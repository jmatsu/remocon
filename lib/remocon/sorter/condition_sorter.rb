# frozen_string_literal: true

module Remocon
  module ConditionSorter
    CONDITION_KEYS = %i[name expression tagColor]

    def sort_conditions(conditions)
      conditions
        .sort_by { |e| e[:name] }
        .map do |e|
        arr = e.sort do |(a, _), (b, _)|
          if !CONDITION_KEYS.include?(a) && !CONDITION_KEYS.include?(b)
            a <=> b
          else
            (CONDITION_KEYS.index(a) || 10000) <=> (CONDITION_KEYS.index(b) || 10000)
          end
        end

        arr.each_with_object({}) { |(k, v), h| h[k] = v }.with_indifferent_access
      end
    end
  end
end
