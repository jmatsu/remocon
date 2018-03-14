# frozen_string_literal: true

module Remocon
  class StringNormalizer < Remocon::Normalizer
    def self.respond_symbol
      Remocon::Type::STRING
    end

    def normalize
      @content&.to_s
    end
  end
end
