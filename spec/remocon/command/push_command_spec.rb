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
        allow(Remocon::Request).to receive(:push)
      end

      it "should call Request#push" do
        expect(Remocon::Request).to receive(:push)

        command.run
      end
    end
  end
end
