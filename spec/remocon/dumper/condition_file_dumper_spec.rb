# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ConditionFileDumper do
    let(:conditions) do
      [
        {
          name: "name1",
          expression: "expression1",
          tagColor: "tagColor1",
          custom1: "custom1",
          custom2: "custom2"
        },
        {
          name: "name2",
          custom2: "custom2",
          tagColor: "tagColor2",
          custom1: "custom1",
          expression: "expression2"
        },
        {
          custom1: "custom1",
          custom2: "custom2",
          expression: "expression3",
          name: "name3",
          tagColor: "tagColor3"
        },
        {
          expression: "expression4",
          tagColor: "tagColor4",
          name: "name4",
          custom2: "custom2",
          custom1: "custom1"
        }
      ]
    end

    context "#dump" do
      it "should return as it is" do
        expect(ConditionFileDumper.new(conditions).dump).to eq(conditions)
      end
    end
  end
end
