# frozen_string_literal: true

module Remocon
  module Command
    class Validate
      include Remocon::InterpreterHelper

      def initialize(opts)
        @opts = opts

        @conditions_filepath = @opts[:conditions]
        @parameters_filepath = @opts[:parameters]

        @cmd_opts = { validate_only: true }
      end

      def run
        validate_options

        if parameter_errors.empty? && condition_errors.empty?
          STDOUT.puts 'No error was found.'
        else
          (parameter_errors + condition_errors).each do |e|
            STDERR.puts "#{e.class} #{e.message}"
            STDERR.puts e.backtrace.join("\n")
          end
        end
      end

      private

      def validate_options
        raise ValidationError, 'A condition file must exist' unless File.exist?(@conditions_filepath)
        raise ValidationError, 'A parameter file must exist' unless File.exist?(@parameters_filepath)
      end
    end
  end
end
