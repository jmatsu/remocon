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
          allow_any_instance_of(Net::HTTPOK).to receive(:header).and_return({ "etag" => "XYZXYZXYZXYZ-0" })
          allow(Remocon::Request).to receive(:validate).and_return([Net::HTTPOK.new(nil, 200, nil), "{}"])
        end

        context "etags are mismatch" do
          before do
            allow(Remocon::Request).to receive(:fetch_etag).and_return("different")
          end

          it "should return an error" do
            expect(command.run).to be_falsey
          end
        end

        context "etags are same" do
          before do
            allow(Remocon::Request).to receive(:fetch_etag).and_return("XYZXYZXYZXYZ")
          end

          it "should not return any errors" do
            expect(command.run).to be_truthy
          end
        end
      end
    end
  end
end
