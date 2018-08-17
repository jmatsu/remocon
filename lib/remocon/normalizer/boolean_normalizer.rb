# frozen_string_literal: true

module Remocon
  class BooleanNormalizer < Remocon::Normalizer
    def self.respond_symbol
      Remocon::Type::BOOLEAN
    end

    def validate
      @bool_val = @content.to_s.to_boolean
    rescue ArgumentError => e
      raise ValidationError, e.message
    end

    def normalize
      @bool_val
    end
  end
end
