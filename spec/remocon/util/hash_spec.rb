# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe Hash do
    let(:target) do
      {
        a: nil,
        b: {
          c: nil,
          d: "remain",
          e: 123,
          f: {
            g: nil,
            h: "remain"
          },
          i: [
            nil,
            "remain"
          ]
        }
      }
    end

    context '#skip_nil_values' do
      it 'should delete keys which has nil' do
        expect(target.skip_nil_values).to eq({
                                               b: {
                                                 d: "remain",
                                                 e: 123,
                                                 f: {
                                                   h: "remain"
                                                 },
                                                 i: [
                                                   "remain"
                                                 ]
                                               }
                                             })
      end
    end

    context '#stringify_values' do
      it 'should have only string values' do
        expect(target.stringify_values).to eq({
                                                a: "",
                                                b: {
                                                  c: "",
                                                  d: "remain",
                                                  e: "123",
                                                  f: {
                                                    g: "",
                                                    h: "remain"
                                                  },
                                                  i: [
                                                    "",
                                                    "remain"
                                                  ]
                                                }
                                              })
      end
    end
  end
end
