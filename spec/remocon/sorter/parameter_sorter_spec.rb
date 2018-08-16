# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ParameterSorter do
    let(:sorter) { Struct.new(:dummy) { include Remocon::ParameterSorter }.new }
    let(:target) do
      {
        key1: {
          value: "value",
          conditions: {
            "cond1" => {
              value: "cond1 value"
            },
            "cond2" => {
              value: "cond2 value"
            }
          },
          normalizer: "json",
          description: "example example example",
          options: {
            option2: "option2",
            option3: "option3",
            option1: "option1"
          }
        },
        key2: {
          description: "example example example",
          normalizer: "json",
          value: "value"
        },
        key3: {
          file: "file",
          description: "example example example",
          normalizer: "json",
          conditions: {
            "cond2" => {
              value: "cond2 value"
            },
            "cond1" => {
              value: "cond1 value"
            }
          },
          options: {
            option3: "option3",
            option2: "option2",
            option1: "option1"
          }
        }
      }
    end

    context "#sort_parameters" do
      it "should sort" do
        sorted_target = sorter.sort_parameters(target)

        expect(sorted_target).to eq({
          key1: {
            description: "example example example",
            value: "value",
            normalizer: "json",
            conditions: {
              "cond1" => {
                value: "cond1 value"
              },
              "cond2" => {
                value: "cond2 value"
              }
            },
            options: {
              option2: "option2",
              option3: "option3",
              option1: "option1"
            }
          },
          key2: {
            description: "example example example",
            value: "value",
            normalizer: "json"
          },
          key3: {
            description: "example example example",
            file: "file",
            normalizer: "json",
            conditions: {
              "cond2" => {
                value: "cond2 value"
              },
              "cond1" => {
                  value: "cond1 value"
              }
            },
            options: {
              option3: "option3",
              option2: "option2",
              option1: "option1"
            }
          }

        }.deep_stringify_keys)

        sorted_target["key3"]["conditions"].each_with_index do |(key, hash), index|
          case index
            when 0
              expect(key).to eq("cond2")
              expect(hash).to eq("value" => "cond2 value")
            when 1
              expect(key).to eq("cond1")
              expect(hash).to eq("value" => "cond1 value")
          end
        end
      end
    end
  end
end
