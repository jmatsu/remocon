# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ParameterFileInterpreter do
    let(:condition_names) { %w(condition1 zxczx) }
    let(:interpreter) { ParameterFileInterpreter.new(fixture_path("#{filename}.yml")) }

    describe "#read" do
      context "when reading a valid condition file" do
        let(:filename) { "valid_parameters" }

        it "should return expected hash" do
          conditions, = interpreter.read(condition_names)

          expect(conditions).to eq(valid_parameters)
        end

        it "should return no errors" do
          _, errors = interpreter.read(condition_names, validate_only: true)

          expect(errors.size).to eq(0)
        end
      end

      context "when reading an invalid condition file" do
        let(:filename) { "invalid_parameters_1" }

        it "should raise an error" do
          expect { interpreter.read(condition_names) }.to raise_error(ValidationError)
        end

        it "should return all errors" do
          _, errors = interpreter.read(condition_names, validate_only: true)

          # DuplicateKeyError is not included cuz YAML loader automatically overwrite that if a duplicated key is found
          expect(errors.size).to eq(1)
          expect(errors.map(&:class)).to include(NotFoundConditionKey)
        end
      end
    end
  end
end
