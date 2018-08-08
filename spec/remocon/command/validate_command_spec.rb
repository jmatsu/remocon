# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Validate do
      let(:command) { Validate.new(options) }

      context "a parameters file is not found" do
        let(:options) do
          {
            parameters: fixture_path("valid_parameters123123123.yml"),
            conditions: fixture_path("valid_conditions.yml")
          }
        end

        it "should raise an error" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "a conditions file is not found" do
        let(:options) do
          {
            parameters: fixture_path("valid_parameters.yml"),
            conditions: fixture_path("valid_conditions123123123.yml")
          }
        end

        it "should raise an error if a conditions file is not found" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "files are valid" do
        let(:options) do
          {
            parameters: fixture_path("valid_parameters.yml"),
            conditions: fixture_path("valid_conditions.yml")
          }
        end

        before do
          allow(STDOUT).to receive(:puts)
          allow(STDERR).to receive(:puts)
        end

        it "should print to stdout but not to stderr" do
          expect(STDOUT).to receive(:puts)
          expect(STDERR).not_to receive(:puts)

          command.run
        end
      end

      context "a parameters file is invalid" do
        let(:options) do
          {
            parameters: fixture_path("invalid_parameters_1.yml"),
            conditions: fixture_path("valid_conditions.yml")
          }
        end

        before do
          allow(STDOUT).to receive(:puts)
          allow(STDERR).to receive(:puts)
        end

        it "should print to stderr" do
          expect(STDERR).to receive(:puts)

          command.run
        end
      end
    end
  end
end
