# frozen_string_literal: true

module Remocon
  class IntegerNormalizer < Remocon::Normalizer
    def self.respond_symbol
      Remocon::Type::INTEGER
    end

    def validate
      return if @content.class == Integer.class

      begin
        @int_val = @content.to_s.to_integer
      rescue ArgumentError => e
        raise ValidationError, e.message
      end
    end

    def normalize
      @int_val
    end
  end
end
