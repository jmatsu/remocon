# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ParameterSorter do

    def to_a(x)
      case x
        when Hash
          to_a(x.to_a)
        when Array
          x.map { |a| to_a(a) }
        else
          x
      end
    end

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

    context "#sort_conditions_of_parameters" do
      let(:conditions) {
        {
            "xyz" => {
                normalizer: "json",
                value: "xyz value"
            },
            "abc" => {
                value: "abc value",
                normalizer: "integer",
            },
            "mute" => {
                normalizer: "integer",
                value: "mute value",
            },
            "curry" => {
                value: "curry value",
                normalizer: "integer",
            },
            "abc123" => {
                normalizer: "integer",
                value: "abc123 value",
            }
        }
      }

      it "shouldn't sort keys" do
        sorted_conditions = sorter.sort_conditions_of_parameters(conditions)

        keys = %w(xyz abc mute curry abc123)

        sorted_conditions.each_with_index do |(key, _), index|
          expect(key).to eq(keys[index])
        end
      end
    end

    context "#sort_parameters" do
      it "should sort" do
        sorted_target = sorter.sort_parameters(target)

        expect(to_a(sorted_target)).to eq(to_a({
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

        }.deep_stringify_keys))
      end
    end
  end
end
