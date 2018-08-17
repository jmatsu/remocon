# frozen_string_literal: true

require "spec_helper"

module Remocon
  module Command
    describe Pull do
      let(:opts) { { prefix: "spec/fixture", id: "pull" } }
      let(:command) { Pull.new(opts) }
      let(:local_configs) { Pull::RemoteConfig.new(opts) }
      let(:new_config_json) { JSON.parse(File.open(fixture_path("pull/new_config.json")).read).with_indifferent_access }

      describe Pull::RemoteConfig do
        it "#conditions_to_be_compared" do
          expect(local_configs.conditions_to_be_compared).to eq(
                                                                 [
                                                                     {
                                                                         "name" => "unchanged_condition",
                                                                         "expression" => "device.os == 'ios'",
                                                                         "tagColor" => "INDIGO",
                                                                     },
                                                                     {
                                                                         "name" => "changed_condition",
                                                                         "expression" => "device.os == 'android'",
                                                                         "tagColor" => "CYAN",
                                                                     },
                                                                     {
                                                                         "name" => "will_be_removed_condition",
                                                                         "expression" => "device.os == 'ios'",
                                                                         "tagColor" => "CYAN",
                                                                     },
                                                                 ]
                                                             )
        end

        it "#parameters_to_be_compared" do
          expect(local_configs.parameters_to_be_compared).to eq(
                                                                   {
                                                                       "changed_parameter" => {
                                                                           "defaultValue" => {
                                                                               "value" => "100"
                                                                           },
                                                                           "conditionalValues" => {
                                                                               "unchanged_condition" => {
                                                                                   "value" => "200"
                                                                               },
                                                                               "will_be_removed_condition" => {
                                                                                   "value" => "100"
                                                                               }
                                                                           }
                                                                       },
                                                                       "unchanged_parameter" => {
                                                                           "defaultValue" => {
                                                                               "value" => "100"
                                                                           },
                                                                           "conditionalValues" => {
                                                                               "unchanged_condition" => {
                                                                                   "value" => "100"
                                                                               },
                                                                               "changed_condition" => {
                                                                                   "value" => "300"
                                                                               },
                                                                           }
                                                                       },
                                                                       "will_be_removed_parameter" => {
                                                                           "defaultValue" => {
                                                                               "value" => "123"
                                                                           }
                                                                       },
                                                                       "unchanged_normalizer_parameter" => {
                                                                           "defaultValue" => {
                                                                               "value" => "123"
                                                                           }
                                                                       },
                                                                       "changed_normalizer_parameter" => {
                                                                           "defaultValue" => {
                                                                               "value" => "false"
                                                                           }
                                                                       },
                                                                   }
                                                             )
        end
      end

      context "#conditions_diff" do
        it "should calculate diffs" do
          unchanged, added, changed, removed = command.conditions_diff(local_configs.conditions_to_be_compared, new_config_json[:conditions])

          expect(unchanged.size).to eq(1)
          expect(added.size).to eq(1)
          expect(changed.size).to eq(1)
          expect(removed.size).to eq(1)
        end

        it "should calculate unchanged diffs" do
          unchanged, = command.conditions_diff(local_configs.conditions_to_be_compared, new_config_json[:conditions])

          expect(local_configs.conditions_to_be_compared.any? { |c| c[:name] == "unchanged_condition" }).to be_truthy
          expect(new_config_json[:conditions].any? { |c| c[:name] == "unchanged_condition" }).to be_truthy
          expect(unchanged.size).to eq(1)
          expect(unchanged.first).to include(
            "expression" => "device.os == 'ios'",
            "name" => "unchanged_condition",
            "tagColor" => "INDIGO"
          )
        end

        it "should calculate added diffs" do
          _, added, = command.conditions_diff(local_configs.conditions_to_be_compared, new_config_json[:conditions])

          expect(local_configs.conditions_to_be_compared.any? { |c| c[:name] == "added_condition" }).to be_falsey
          expect(new_config_json[:conditions].any? { |c| c[:name] == "added_condition" }).to be_truthy
          expect(added.size).to eq(1)
          expect(added.first).to include(
            "expression" => "device.os == 'android'",
            "name" => "added_condition",
            "tagColor" => "INDIGO"
          )
        end

        it "should calculate changed diffs" do
          _, _, changed, = command.conditions_diff(local_configs.conditions_to_be_compared, new_config_json[:conditions])

          expect(local_configs.conditions_to_be_compared.any? { |c| c[:name] == "changed_condition" }).to be_truthy
          expect(new_config_json[:conditions].any? { |c| c[:name] == "changed_condition" }).to be_truthy
          expect(changed.size).to eq(1)
          expect(changed.first).to include(
            "expression" => "device.os == 'ios'",
            "name" => "changed_condition",
            "tagColor" => "CYAN"
          )
        end

        it "should calculate removed diffs" do
          _, _, _, removed = command.conditions_diff(local_configs.conditions_to_be_compared, new_config_json[:conditions])

          expect(local_configs.conditions_to_be_compared.any? { |c| c[:name] == "will_be_removed_condition" }).to be_truthy
          expect(new_config_json[:conditions].any? { |c| c[:name] == "will_be_removed_condition" }).to be_falsey
          expect(removed.size).to eq(1)
          expect(removed.first).to include(
            "expression" => "device.os == 'ios'",
            "name" => "will_be_removed_condition",
            "tagColor" => "CYAN"
          )
        end
      end

      context "#parameters_diff" do
        it "should calculate diffs" do
          unchanged, added, changed, removed = command.parameters_diff(local_configs.parameters_to_be_compared, new_config_json[:parameters])

          expect(unchanged.size).to eq(2)
          expect(added.size).to eq(1)
          expect(changed.size).to eq(2)
          expect(removed.size).to eq(1)
        end

        it "should calculate unchanged diffs" do
          unchanged, = command.parameters_diff(local_configs.parameters_to_be_compared, new_config_json[:parameters])

          expect(local_configs.parameters_to_be_compared.keys).to include("unchanged_parameter")
          expect(new_config_json[:parameters].keys).to include("unchanged_parameter")
          expect(unchanged.size).to eq(2)
          expect(unchanged).to include(
            "unchanged_parameter" => {
                "value" => "100",
                "conditions" => {
                    "unchanged_condition" => {
                        "value" => "100"
                    },
                    "changed_condition" => {
                        "value" => "300"
                    }
                }
            },
            "unchanged_normalizer_parameter" => {
                "value" => "123"
            }
          )
        end

        it "should calculate added diffs" do
          _, added, = command.parameters_diff(local_configs.parameters_to_be_compared, new_config_json[:parameters])

          expect(local_configs.parameters_to_be_compared.keys).not_to include("added_parameter")
          expect(new_config_json[:parameters].keys).to include("added_parameter")
          expect(added.size).to eq(1)
          expect(added).to include(
            "added_parameter" => {
                "value" => "1230947"
            }
          )
        end

        it "should calculate changed diffs" do
          _, _, changed, = command.parameters_diff(local_configs.parameters_to_be_compared, new_config_json[:parameters])

          expect(local_configs.parameters_to_be_compared.keys).to include("changed_parameter")
          expect(new_config_json[:parameters].keys).to include("changed_parameter")
          expect(changed.size).to eq(2)

          expect(changed).to include(
            "changed_parameter" => {
              "value" => "100",
              "conditions" => {
                  "unchanged_condition" => {
                      "value" => "200"
                  }
              }
            },
            "changed_normalizer_parameter" => {
                "value" => "true"
            }
          )
        end

        it "should calculate removed diffs" do
          _, _, _, removed = command.parameters_diff(local_configs.parameters_to_be_compared, new_config_json[:parameters])

          expect(local_configs.parameters_to_be_compared.keys).to include("will_be_removed_parameter")
          expect(new_config_json[:parameters].keys).not_to include("will_be_removed_parameter")
          expect(removed.size).to eq(1)
          expect(removed).to include(
            "will_be_removed_parameter" => {
                "value" => "123",
            }
          )
        end
      end
    end
  end
end
