# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe String do
    context 'successful conversion' do
      it 'should be integer' do
        expect('123'.to_integer).to be 123
      end

      it 'should be boolean' do
        expect('true'.to_boolean).to be true
        expect('false'.to_boolean).to be false
      end
    end

    context 'failure conversion' do
      it 'should throw an exception' do
        expect { '123 ab'.to_integer }.to raise_error(ArgumentError)
        expect { 'curry rice'.to_integer }.to raise_error(ArgumentError)
      end

      it 'should throw an exception' do
        expect { 'this is not valid'.to_boolean }.to raise_error(ArgumentError)
      end
    end
  end
end
