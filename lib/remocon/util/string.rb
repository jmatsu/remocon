# frozen_string_literal: true

class String
  def to_integer
    Integer(self)
  end

  def to_boolean
    return true if self == "true"
    return false if self == "false"
    raise ArgumentError, 'String cannot be converted to Boolean'
  end
end
