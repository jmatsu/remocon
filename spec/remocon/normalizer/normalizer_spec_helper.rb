# frozen_string_literal: true

require "spec_helper"

module Remocon
  module NormalizerSpecHelper
    shared_examples 'respond symbol check' do
      # klass, respond_symbol

      it "should respond to the symbol" do
        expect(klass.respond_symbol).to eq(respond_symbol)
      end
    end

    shared_examples "validation error" do
      # klass, content
      let(:normalizer) { klass.new(content, {}) }

      it 'should detect invalid state' do
        expect { normalizer.validate }.to raise_error(ValidationError)
      end
    end

    shared_examples "validation successfully" do
      # klass, content
      let(:normalizer) { klass.new(content, {}) }

      it 'should pass valid state' do
        normalizer.validate
      end
    end

    shared_examples "normalize" do
      # klass, content, expected
      let(:normalizer) { klass.new(content, {}) }

      it 'should normalize content' do
        # normalize must be called after validation, so it's okay to just test process
        normalizer.process
        expect(normalizer.content).to eq(expected)
      end
    end
  end
end
