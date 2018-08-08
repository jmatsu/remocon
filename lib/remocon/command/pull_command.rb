# frozen_string_literal: true

module Remocon
  module Command
    class Pull
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
        raw_json, etag = do_request

        if config.project_dir_path
          FileUtils.mkdir_p(config.project_dir_path)

          raw_hash = JSON.parse(raw_json).with_indifferent_access

          raise "etag cannot be fetched. please try again" unless etag

          conditions = raw_hash[:conditions] || []
          parameters = raw_hash[:parameters] || {}

          File.open(config.conditions_file_path, "w+") do |f|
            f.write(JSON.parse(Remocon::ConditionFileDumper.new(sort_conditions(conditions)).dump.to_json).to_yaml)
            f.flush
          end

          File.open(config.parameters_file_path, "w+") do |f|
            f.write(JSON.parse(Remocon::ParameterFileDumper.new(sort_parameters(parameters)).dump.to_json).to_yaml)
            f.flush
          end

          File.open(config.config_json_file_path, "w+") do |f|
            f.write(JSON.pretty_generate({ conditions: sort_conditions(conditions), parameters: sort_parameters(parameters) }))
            f.flush
          end

          File.open(config.etag_file_path, "w+") do |f|
            f.write(etag)
            f.flush
          end
        else
          STDERR.puts etag
          STDOUT.puts raw_json
        end
      end

      private

      def do_request
        raw_json, etag = open(config.endpoint, "Authorization" => "Bearer #{config.token}") do |io|
          [io.read, io.meta["etag"]]
        end

        [raw_json, etag]
      end
    end
  end
end
