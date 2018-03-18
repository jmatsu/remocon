# frozen_string_literal: true

module Remocon
  class ParameterFileInterpreter
    def initialize(filepath)
      @yaml = YAML.safe_load(File.open(filepath).read).with_indifferent_access
    end

    def read(condition_names, opts = {})
      errors = []
      json_hash = @yaml.each_with_object({}) do |(key, body), hash|
        raise Remocon::DuplicateKeyError, "#{key} is duplicated" if hash[key]

        hash[key] = {
          defaultValue: {
            value: parse_value_body(key, body)
          }
        }

        hash[key][:conditionalValues] = parse_condition_body(condition_names, key, body[:conditions]) if body[:conditions]
        hash[key][:description] = body[:description] if body[:description]
      rescue Remocon::ValidationError => e
        raise e unless opts[:validate_only]
        errors.push(e)
      end

      [json_hash.with_indifferent_access, errors]
    end

    private

    def read_value(body)
      body[:file] ? File.open(body[:file]).read : body[:value]
    end

    def parse_value_body(key, value_body)
      case value_body
      when Hash
        value = read_value(value_body)
        options = { key: key }.merge(value_body[:options] || {})
        normalizer = TypeNormalizerFactory.get(value_body[:normalizer]).new(value, options)
        normalizer.process
        normalizer.content
      else # includes Array
        # use raw value
        value_body
      end
    end

    def parse_condition_body(condition_names, key, condition_body)
      condition_body.each_with_object({}) do |(cond_key, body), hash|
        raise Remocon::NotFoundConditionKey, "The condition '#{cond_key}' is not defined" unless condition_names.include?(cond_key.to_s)

        hash[cond_key] = {
          value: parse_value_body(key, body)
        }
      end
    end
  end
end
