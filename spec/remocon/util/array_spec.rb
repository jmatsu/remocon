# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe Array do
    let(:target) do
      [
        nil,
        :a,
        "remain",
        123,
        nil,
        {
          c: nil,
          d: "remain"
        }
      ]
    end

    context "#stringify_values" do
      it "should have only string values" do
        expect(target.stringify_values).to eq([
                                                "",
                                                "a",
                                                "remain",
                                                "123",
                                                "",
                                                {
                                                  c: "",
                                                  d: "remain"
                                                }
                                              ])
      end
    end
  end
end
