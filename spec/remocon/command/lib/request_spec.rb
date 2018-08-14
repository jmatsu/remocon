# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe Request do

    let(:opts) { { id: "fixture", "raw-etag": "raw_etag", token: "valid_token", prefix: "spec" } }
    let(:config) { Config.new(opts) }

    before do
      allow(Request).to receive(:open)
      allow_any_instance_of(Net::HTTP).to receive(:request).with(any_args).and_return(double("response double"))
    end

    context "#push" do
      it "should send a json request with an etag and a token" do
        expect(Net::HTTP::Put).to receive(:new).with(URI.parse("https://firebaseremoteconfig.googleapis.com/v1/projects/fixture/remoteConfig").request_uri, any_args) do |_, headers|
          expect(headers).to include(
                                 "Authorization" => "Bearer valid_token",
                                 "Content-Type" => "application/json; UTF8",
                                 "If-Match" => "raw_etag",
                                 )
        end.and_call_original

        Request.push(config)
      end
    end

    context "#pull" do
      it "should request with a token" do
        expect(Request).to receive(:open).with("https://firebaseremoteconfig.googleapis.com/v1/projects/fixture/remoteConfig", {
            "Authorization" => "Bearer valid_token"
        })

        Request.pull(config)
      end
    end

    context "#fetch_etag" do
      it "should send a compressed json request with a token" do
        expect(Net::HTTP::Get).to receive(:new).with(URI.parse("https://firebaseremoteconfig.googleapis.com/v1/projects/fixture/remoteConfig").request_uri, any_args) do |_, headers|
          expect(headers).to include(
                                     "Authorization" => "Bearer valid_token",
                                     "Content-Type" => "application/json; UTF8",
                                     "Content-Encoding" => "gzip",
                                 )
        end.and_call_original

        Request.fetch_etag(config)
      end
    end
  end
end
