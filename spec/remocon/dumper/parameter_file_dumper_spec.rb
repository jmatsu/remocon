# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ParameterFileDumper do
    let(:parameters) do
      json = <<~EOS
        {
            "key1": {
              "defaultValue": {
                "value": "100"
              },
              "conditionalValues": {
                "condition1": {
                  "value": "200"
                },
                "zxczx": {
                  "value": "100"
                }
              }
            },
            "key2": {
              "defaultValue": {
                "value": "123"
              },
              "description": "this is a description"
            }
          }
      EOS
      JSON.parse(json).with_indifferent_access
    end

    context "#dump" do
      it "should return as it is" do
        yaml = <<~EOS
          key1:
            value: '100'
            conditions:
              condition1:
                value: '200'
              zxczx:
                value: '100'
          key2:
            value: '123'
            description: this is a description
        EOS

        expect(ParameterFileDumper.new(parameters).dump).to eq(YAML.safe_load(yaml).with_indifferent_access)
      end
    end
  end
end
