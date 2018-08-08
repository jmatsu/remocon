# frozen_string_literal: true

class Array
  def stringify_values
    map do |e|
      if e.kind_of?(Hash)
        e.stringify_values
      elsif e.kind_of?(Array)
        e.stringify_values
      else
        e.to_s
      end
    end
  end
end
