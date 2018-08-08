# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe CLI do
    context "commands" do
      shared_examples "CLI examples" do
        it "should run a command" do
          # disable running
          allow(klass).to receive(:run)

          expect_any_instance_of(klass).to receive(:run).once
          described_class.new.invoke(command, [], options)
        end
      end

      describe "create" do
        let(:klass)   { Remocon::Command::Create }
        let(:command) { :create }

        let(:options) { { parameters: "", conditions: "" } }

        it_behaves_like "CLI examples"
      end

      describe "pull" do
        let(:klass)   { Remocon::Command::Pull }
        let(:command) { :pull }

        let(:options) { {} }

        it_behaves_like "CLI examples"
      end

      describe "push" do
        let(:klass)   { Remocon::Command::Push }
        let(:command) { :push }

        let(:options) { { source: "" } }

        it_behaves_like "CLI examples"
      end

      describe "validate" do
        let(:klass)   { Remocon::Command::Validate }
        let(:command) { :validate }

        let(:options) { { parameters: "", conditions: "" } }

        it_behaves_like "CLI examples"
      end
    end
  end
end
