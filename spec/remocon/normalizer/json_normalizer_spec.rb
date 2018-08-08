# frozen_string_literal: true

require "spec_helper"
require_relative "./normalizer_spec_helper"

module Remocon
  module IntegerNormalizerSpec
    include Remocon::NormalizerSpecHelper

    describe JsonNormalizer do
      let(:klass) { Remocon::JsonNormalizer }
      let(:respond_symbol) { Remocon::Type::JSON }

      describe "respond symbol" do
        it_behaves_like "respond symbol check"
      end

      describe "validate" do
        context "nil" do
          let(:content) { nil }

          it_behaves_like "validation error"
        end

        context "invalid json" do
          let(:content) { "{ xxxx : yyyy }" }

          it_behaves_like "validation error"
        end

        context "any string" do
          let(:content) { "any string" }

          it_behaves_like "validation error"
        end

        context "json string" do
          let(:content) { '{ "key1" : "any string" }' }

          it_behaves_like "validation successfully"
        end

        context "float value" do
          let(:content) { 4.32 }

          it_behaves_like "validation error"
        end

        context "integer" do
          let(:content) { 123_123 }

          it_behaves_like "validation error"
        end

        context "hash" do
          let(:content) { { key1: "value1", key2: { key3: "value3" } } }

          it_behaves_like "validation successfully"
        end
      end

      describe "normalize" do
        context "when json string is given" do
          let(:content) { '{ "key1" : "any string" }' }
          let(:expected) { JSON.parse('{ "key1" : "any string" }').to_json }

          it_behaves_like "normalize"
        end

        context "when hash is given" do
          let(:content) { { key1: "any string" } }
          let(:expected) { JSON.parse('{ "key1" : "any string" }').to_json }

          it_behaves_like "normalize"
        end
      end
    end
  end
end
