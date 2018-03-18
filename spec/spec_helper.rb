# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require 'remocon'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path(fixture_name)
  File.join(File.dirname(__FILE__), "fixture", fixture_name)
end

def valid_parameters
  JSON.parse(<<~JSON
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
        }
      }
    }
  JSON
            ).with_indifferent_access
end

def valid_conditions
  JSON.parse(<<~JSON
    [
      {
        "name":"condition1",
        "expression":"device.os == 'ios'",
        "tagColor":"INDIGO"
      },
      {
        "name":"zxczx",
        "expression":"device.os == 'ios'",
        "tagColor":"CYAN"
      }
    ]
  JSON
            ).map(&:with_indifferent_access)
end

def config_json
  JSON.parse(File.open(fixture_path('config.json')).read).with_indifferent_access
end

ENV['FIREBASE_PROJECT_ID'] = 'project_id'
ENV['REMOTE_CONFIG_ACCESS_TOKEN'] = 'token'
