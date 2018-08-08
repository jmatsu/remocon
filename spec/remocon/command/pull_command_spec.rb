# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Pull do
      let(:command) { Pull.new({ token: "xyz", id: "dragon" }) }

      before do
        allow(command).to receive(:open)
      end

      context "#run" do
        it "should request with GET to a correct url" do
          expect(command).to receive(:open).with("https://firebaseremoteconfig.googleapis.com/v1/projects/dragon/remoteConfig", {
                                                   "Authorization" => "Bearer xyz"
                                                 })

          command.send("do_request")
        end
      end
    end
  end
end
