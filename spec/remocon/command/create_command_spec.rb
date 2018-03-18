# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Create do
      let(:command) { Create.new(options) }

      context 'a parameters file is not found' do
        let(:options) do
          {
            parameters: fixture_path('valid_parameters123123123.yml'),
            conditions: fixture_path('valid_conditions.yml')
          }
        end

        it 'should raise an error' do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context 'a conditions file is not found' do
        let(:options) do
          {
            parameters: fixture_path('valid_parameters.yml'),
            conditions: fixture_path('valid_conditions123123123.yml')
          }
        end

        it 'should raise an error if a conditions file is not found' do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context 'files are valid' do
        let(:options) do
          {
            parameters: fixture_path('valid_parameters.yml'),
            conditions: fixture_path('valid_conditions.yml')
          }
        end

        it 'should return a json which will be a result' do
          expect(command.run.deep_stringify_keys).to eq(config_json)
        end
      end

      context 'a parameters file is invalid' do
        let(:options) do
          {
            parameters: fixture_path('invalid_parameters_1.yml'),
            conditions: fixture_path('valid_conditions.yml')
          }
        end

        it 'should raise an error' do
          expect { command.run }.to raise_error(ValidationError)
        end
      end
    end
  end
end
