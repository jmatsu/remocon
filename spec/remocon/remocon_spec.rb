# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe VERSION do
    it "has a version number" do
      expect(Remocon::VERSION).not_to be nil
    end
  end
end
