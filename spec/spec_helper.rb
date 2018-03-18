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
