# frozen_string_literal: true

module Remocon
  class VoidNormalizer < Remocon::Normalizer
    def self.respond_symbol
      Remocon::Type::VOID
    end
  end
end
