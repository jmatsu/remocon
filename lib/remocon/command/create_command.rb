# frozen_string_literal: true

module Remocon
  module Command
    class Create
      include Remocon::InterpreterHelper

      def initialize(opts)
        @opts = opts

        @project_id = ENV.fetch('FIREBASE_PROJECT_ID')
        @conditions_filepath = @opts[:conditions]
        @parameters_filepath = @opts[:parameters]
        @dest_dir = File.join(@opts[:dest], @project_id) if @opts[:dest]

        @cmd_opts = { validate_only: false }
      end

      def run
        validate_options

        artifact = {
          conditions: condition_array,
          parameters: parameter_hash
        }

        if @dest_dir
          File.open(File.join(@dest_dir, 'config.json'), 'w+') do |f|
            # remote config allows only string values ;(
            f.write(JSON.pretty_generate(artifact.skip_nil_values.stringify_values))
            f.flush
          end
        else
          STDOUT.puts JSON.pretty_generate(artifact.skip_nil_values)
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
