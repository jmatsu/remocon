# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe TypeNormalizerFactory do
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

    # this feature is a prototype so it's okay to add ignore marker if this fails
    context "#register" do
      it "should return as it is" do
        expect(TypeNormalizerFactory.get(:dummy)).to eq(nil)

        class DummyNormalizer < Remocon::Normalizer
          def self.respond_symbol
            :dummy
          end
        end

        TypeNormalizerFactory.register(DummyNormalizer)

        expect(TypeNormalizerFactory.get(:dummy)).to eq(DummyNormalizer)
      end
    end

    context "#get" do
      it "should return a corresponding normalizer" do
        expect(TypeNormalizerFactory.get(Remocon::Type::STRING)).to eq(StringNormalizer)
        expect(TypeNormalizerFactory.get(Remocon::Type::INTEGER)).to eq(IntegerNormalizer)
        expect(TypeNormalizerFactory.get(Remocon::Type::BOOLEAN)).to eq(BooleanNormalizer)
        expect(TypeNormalizerFactory.get(Remocon::Type::JSON)).to eq(JsonNormalizer)
        expect(TypeNormalizerFactory.get(Remocon::Type::VOID)).to eq(VoidNormalizer)
      end
    end
  end
end
