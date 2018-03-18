# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ConditionFileInterpreter do
    let(:interpreter) { ConditionFileInterpreter.new(fixture_path("#{filename}.yml")) }

    describe '#read' do
      context 'when reading a valid condition file' do
        let(:filename) { 'valid_conditions' }

        it 'should return expected array' do
          conditions, = interpreter.read

          expect(conditions).to eq(
            JSON.parse(<<~JSON
              [
                {
                  "name":"condition1",
                  "expression":"device.os == 'ios'",
                  "tagColor":"INDIGO"
                },
                {
                  "name":"zxczx",
                  "expression":"device.os == 'ios'",
                  "tagColor":"CYAN"
                }
              ]
            JSON
                      )
          )
        end

        it 'should return no errors' do
          _, errors = interpreter.read(validate_only: true)

          expect(errors.size).to eq(0)
        end
      end

      context 'when reading an invalid condition file' do
        let(:filename) { 'invalid_conditions_1' }

        it 'should raise an error' do
          expect { interpreter.read }.to raise_error(ValidationError)
        end

        it 'should return all errors' do
          _, errors = interpreter.read(validate_only: true)

          expect(errors.size).to eq(1)
          expect(errors.first.class).to eq(EmptyNameError)
        end
      end

      context 'when reading another invalid condition file' do
        let(:filename) { 'invalid_conditions_2' }

        it 'should raise an error' do
          expect { interpreter.read }.to raise_error(ValidationError)
        end

        it 'should return all errors' do
          _, errors = interpreter.read(validate_only: true)

          expect(errors.size).to eq(3)
          expect(errors.map(&:class)).to include(EmptyNameError, EmptyExpressionError, DuplicateKeyError)
        end
      end
    end
  end
end
