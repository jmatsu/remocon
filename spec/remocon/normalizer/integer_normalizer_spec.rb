# frozen_string_literal: true

require "spec_helper"
require_relative './normalizer_spec_helper'

module Remocon
  module IntegerNormalizerSpec
    include Remocon::NormalizerSpecHelper

    describe IntegerNormalizer do
      let(:klass) { Remocon::IntegerNormalizer }
      let(:respond_symbol) { Remocon::Type::INTEGER }

      describe "respond symbol" do
        it_behaves_like 'respond symbol check'
      end

      describe "validate" do
        context 'nil' do
          let(:content) { nil }

          it_behaves_like "validation error"
        end

        context 'not integer string' do
          let(:content) { 'any string' }

          it_behaves_like "validation error"
        end

        context 'float value' do
          let(:content) { 4.32 }

          it_behaves_like "validation error"
        end

        context 'integer string' do
          let(:content) { '2345' }

          it_behaves_like "validation successfully"
        end

        context 'integer' do
          let(:content) { 123123 }

          it_behaves_like "validation successfully"
        end
      end

      describe "normalize" do
        context 'when integer string is given' do
          let(:content) { '123' }
          let(:expected) { 123 }

          it_behaves_like "normalize"
        end

        context 'when integer is given' do
          let(:content) { 432 }
          let(:expected) { 432 }

          it_behaves_like "normalize"
        end
      end
    end
  end
end
