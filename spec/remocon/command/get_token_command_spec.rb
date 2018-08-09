# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe GetToken do
      let(:command) { GetToken.new(options) }

      context "a service account json file is not found" do
        let(:options) do
          {
              "service-json": fixture_path("xyz")
          }
        end

        it "should raise an error" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "no opts" do
        let(:options) do
          {
          }
        end

        it "should raise an error" do
          expect { command.run }.to raise_error(ValidationError)
        end
      end

      context "a service account json file is found" do
        let(:options) do
          {
              "service-json": fixture_path("service_account_dummy.json")
          }
        end

        let(:credentials) { double("credentials", access_token: "access_token", fetch_access_token!: "") }

        before do
          allow(Google::Auth::ServiceAccountCredentials).to receive(:make_creds).and_return(credentials)
        end

        it "should raise an error" do
          expect(command.run).to be("access_token")
        end
      end
    end
  end
end
