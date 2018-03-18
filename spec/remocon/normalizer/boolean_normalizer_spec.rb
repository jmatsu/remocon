# frozen_string_literal: true

require "spec_helper"
require_relative './normalizer_spec_helper'

module Remocon
  module BooleanNormalizerSpec
    include Remocon::NormalizerSpecHelper

    describe BooleanNormalizer do
      let(:klass) { Remocon::BooleanNormalizer }
      let(:respond_symbol) { Remocon::Type::BOOLEAN }

      describe "respond symbol" do
        it_behaves_like 'respond symbol check'
      end

      describe "validate" do
        context 'neither of true or false' do
          let(:content) { 'not false string' }

          it_behaves_like "validation error"
        end

        context 'nil' do
          let(:content) { nil }

          it_behaves_like "validation error"
        end

        context 'true string' do
          let(:content) { 'true' }

          it_behaves_like "validation successfully"
        end

        context 'false string' do
          let(:content) { 'false' }

          it_behaves_like "validation successfully"
        end
      end

      describe "normalize" do
        context 'when true is given' do
          let(:content) { 'true' }
          let(:expected) { true }

          it_behaves_like "normalize"
        end

        context 'when false is given' do
          let(:content) { 'false' }
          let(:expected) { false }

          it_behaves_like "normalize"
        end
      end
    end
  end
end
