# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Push do
      let(:command) { Push.new(options) }
      let(:base_options) do
        {
          source: fixture_path("config_file.json"),
          token: "xyz",
          id: "dragon",
        }
      end

      before do
        allow(command).to receive(:do_request)
      end

      describe "#request" do
        context "a etag is not provided" do
          let(:options) { base_options }

          it "should raise an error without force option" do
            expect { command.request }.to raise_error(StandardError)
          end
        end
        context "a etag file is provided but not found" do
          let(:options) { base_options.merge({ etag: "etag" }) }

          it "should raise an error without force option" do
            expect { command.request }.to raise_error(StandardError)
          end
        end

        context "a etag is not provided but force option is provided" do
          let(:options) { base_options.merge({ force: true }) }

          it "can create a request with force option" do
            expect(command.request["If-Match"]).to eq("*")
          end
        end

        context "a raw etag is provided" do
          let(:options) { base_options.merge({ raw_etag: "ascasc" }) }

          it "can create a correct request without force option" do
            request = command.request

            expect(request["Authorization"]).to eq("Bearer xyz")
            expect(request["Content-Type"]).to eq("application/json; UTF8")
            expect(request["If-Match"]).to eq("ascasc")
            expect(request.path).to eq("/v1/projects/dragon/remoteConfig")
          end
        end
      end

      describe "#client" do
        let(:options) { base_options.merge({ etag: "etag" }) }

        it "should contain a correct host" do
          expect(command.client.address).to eq("firebaseremoteconfig.googleapis.com")
        end
      end
    end
  end
end
