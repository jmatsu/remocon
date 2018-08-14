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
            conditions: fixture_path("valid_conditions.yml"),
            id: "dragon"
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
              conditions: fixture_path("valid_conditions123123123.yml"),
              id: "dragon"
          }
        end

        it "should raise an error if a conditions file is not found" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "etag is not found" do
        let(:options) do
          {
              parameters: fixture_path("valid_parameters.yml"),
              conditions: fixture_path("valid_conditions.yml"),
              etag: fixture_path("etag_file_not_found"),
              id: "dragon"
          }
        end

        it "should raise an error if a etag file is not found" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "dragon is not found" do
        let(:options) do
          {
              parameters: fixture_path("valid_parameters.yml"),
              conditions: fixture_path("valid_conditions.yml"),
              etag: fixture_path("etag_file"),
          }
        end

        it "should raise an error if a dragon is not specified" do
          expect { command.run }.to raise_error(RuntimeError)
        end
      end

      context "all are valid" do
        let(:options) do
          {
            parameters: fixture_path("valid_parameters.yml"),
            conditions: fixture_path("valid_conditions.yml"),
            etag: fixture_path("etag_file"),
            id: "dragon",
            token: "valid_token"
          }
        end

        before do
          allow(STDOUT).to receive(:puts)
          allow(STDERR).to receive(:puts)
        end

        context "etags are mismatch" do
          before do
            allow(Remocon::Request).to receive(:fetch_etag).and_return("different")
          end

          it "should return an error" do
            expect(command).to receive(:print_errors).with(any_args) do |errors|
              expect(errors.any? { |e| e.kind_of?(ValidationError)}).to be_truthy
            end

            expect(command.run).to be_falsey
          end
        end

        context "etags are same" do
          before do
            allow(Remocon::Request).to receive(:fetch_etag).and_return("XYZXYZXYZXYZ")
          end

          it "should not return any errors" do
            expect(command).to receive(:print_errors).with([])
            expect(command.run).to be_truthy
          end
        end
      end

      context "a parameters file is invalid" do
        let(:options) do
          {
            parameters: fixture_path("invalid_parameters_1.yml"),
            conditions: fixture_path("valid_conditions.yml"),
            etag: fixture_path("etag_file"),
            id: "dragon",
            token: "valid_token"
          }
        end

        before do
          allow(Remocon::Request).to receive(:fetch_etag).and_return("XYZXYZXYZXYZ")
        end

        it "should return an error" do
          expect(command).to receive(:print_errors).with(any_args) do |errors|
            expect(errors.any? { |e| e.kind_of?(ValidationError)}).to be_truthy
          end

          expect(command.run).to be_falsey
        end
      end
    end
  end
end
