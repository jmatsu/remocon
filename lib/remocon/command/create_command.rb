# frozen_string_literal: true

module Remocon
  module Command
    class Create
      include Remocon::InterpreterHelper

      attr_reader :config, :cmd_opts

      def initialize(opts)
        @config = Remocon::Config.new(opts)
        @cmd_opts = { validate_only: false }
      end

      def require_parameters_file_path
        config.parameters_file_path
      end

      def require_conditions_file_path
        config.conditions_file_path
      end

      def run
        validate_options

        artifact = {
          conditions: condition_array,
          parameters: parameter_hash
        }.skip_nil_values.stringify_values

        if config.project_dir_path
          File.open(config_json_file_path, "w+") do |f|
            # remote config allows only string values ;(
            f.write(JSON.pretty_generate(artifact))
            f.flush
          end
        else
          STDOUT.puts JSON.pretty_generate(artifact)
        end

        artifact
      end

      private

      def validate_options
        raise ValidationError, "A condition file must exist" unless File.exist?(config.conditions_file_path)
        raise ValidationError, "A parameter file must exist" unless File.exist?(config.parameters_file_path)
      end
    end
  end
end
