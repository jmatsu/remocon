# frozen_string_literal: true

class Array
  def stringify_values
    map do |e|
      if e.is_a?(Hash)
        e.stringify_values
      elsif e.is_a?(Array)
        e.stringify_values
      else
        e.to_s
      end
    end
  end
end
