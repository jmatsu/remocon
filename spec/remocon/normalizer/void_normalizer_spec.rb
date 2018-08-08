# frozen_string_literal: true

require "spec_helper"
require_relative "./normalizer_spec_helper"

module Remocon
  module VoidNormalizerSpec
    include Remocon::NormalizerSpecHelper

    describe VoidNormalizer do
      let(:klass) { Remocon::VoidNormalizer }
      let(:respond_symbol) { Remocon::Type::VOID }

      describe "respond symbol" do
        it_behaves_like "respond symbol check"
      end

      describe "validate" do
        context "nil" do
          let(:content) { nil }

          it_behaves_like "validation successfully"
        end

        context "any string" do
          let(:content) { "any" }

          it_behaves_like "validation successfully"
        end

        context "boolean" do
          let(:content) { true }

          it_behaves_like "validation successfully"
        end

        context "integer" do
          let(:content) { 123 }

          it_behaves_like "validation successfully"
        end
      end

      describe "normalize" do
        context "when nil is given" do
          let(:content) { nil }
          let(:expected) { nil }

          it_behaves_like "normalize"
        end

        context "when any strings is given" do
          let(:content) { "this is a string" }
          let(:expected) { "this is a string" }

          it_behaves_like "normalize"
        end

        context "when boolean is given" do
          let(:content) { true }
          let(:expected) { true }

          it_behaves_like "normalize"
        end

        context "when integer is given" do
          let(:content) { 123 }
          let(:expected) { 123 }

          it_behaves_like "normalize"
        end
      end
    end
  end
end
