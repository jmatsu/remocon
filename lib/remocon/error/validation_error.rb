# frozen_string_literal: true

module Remocon
  class ValidationError < StandardError; end

  class EmptyNameError < ValidationError; end
  class EmptyExpressionError < ValidationError; end
  class DuplicateKeyError < ValidationError; end
  class NotFoundConditionKey < ValidationError; end
end
