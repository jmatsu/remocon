# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Pull do
      let(:command) { Pull.new({}) }

      before do
        allow(command).to receive(:open)
      end

      context "#run" do
        it "should request with GET to a correct url" do
          expect(command).to receive(:open).with("https://firebaseremoteconfig.googleapis.com/v1/projects/project_id/remoteConfig", {
                                                   "Authorization" => "Bearer token"
                                                 })

          command.run
        end
      end
    end
  end
end
