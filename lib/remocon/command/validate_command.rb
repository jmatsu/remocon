# frozen_string_literal: true

module Remocon
  class ValidateCommand
    include Remocon::InterpreterHelper

    def initialize(opts)
      @opts = opts

      @conditions_filepath = @opts[:conditions]
      @parameters_filepath = @opts[:parameters]

      @cmd_opts = { validate_only: true }
    end

    def run
      if parameter_errors.empty? && condition_errors.empty?
        STDOUT.puts 'No error was found.'
      else
        (parameter_errors + condition_errors).each do |e|
          STDERR.puts "#{e.class} #{e.message}"
          STDERR.puts e.backtrace.join("\n")
        end
      end
    end
  end
end
