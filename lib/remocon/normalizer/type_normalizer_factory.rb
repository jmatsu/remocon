# frozen_string_literal: true

module Remocon
  class TypeNormalizerFactory
    include Singleton

    def self.register(normalizer_klass)
      raise "#{normalizer_klass} must inherit #{Remocon::Normalizer}" unless normalizer_klass < Remocon::Normalizer
      instance.plugin_map[normalizer_klass.respond_symbol] = normalizer_klass
    end

    def self.get(normalizer_sym)
      instance.plugin_map[normalizer_sym&.to_sym || Remocon::Type::VOID]
    end

    def plugin_map
      return @plugin_map if @plugin_map
      @plugin_map = {}

      Remocon::Normalizer.subclasses.each { |klass| Remocon::TypeNormalizerFactory.register(klass) }

      @plugin_map
    end
  end
end
