# frozen_string_literal: true

module Remocon
  class JsonNormalizer < Remocon::Normalizer
    def self.respond_symbol
      Remocon::Type::JSON
    end

    def validate
      str_content = @content.kind_of?(Hash) ? @content.to_json : @content.to_s
      puts str_content
      @json = JSON.parse(str_content).to_json
    rescue JSON::ParserError => e
      raise ValidationError, e.message
    end

    def normalize
      @json
    end
  end
end
