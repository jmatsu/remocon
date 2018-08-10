# frozen_string_literal: true

module Remocon
  module Command
    class Pull
      class RemoteConfig
        include Remocon::InterpreterHelper

        attr_reader :config

        def initialize(opts)
          @config = Remocon::Config.new(opts)
        end

        def require_parameters_file_path
          config.parameters_file_path
        end

        def require_conditions_file_path
          config.conditions_file_path
        end

        def raw_conditions
          YAML.safe_load(File.open(require_conditions_file_path).read)
        end

        def raw_parameters
          YAML.safe_load(File.open(require_parameters_file_path).read).with_indifferent_access
        end
      end

      include Remocon::InterpreterHelper

      attr_reader :config, :cmd_opts, :left

      def initialize(opts)
        @config = Remocon::Config.new(opts)
        @cmd_opts = { validate_only: false }
        @left = RemoteConfig.new(opts)
      end

      def require_parameters_file_path
        config.parameters_file_path
      end

      def require_conditions_file_path
        config.conditions_file_path
      end

      def run
        raw_json, etag = do_request

        raw_hash = JSON.parse(raw_json).with_indifferent_access

        raise "etag cannot be fetched. please try again" unless etag

        conditions = raw_hash[:conditions] || []
        parameters = raw_hash[:parameters] || {}

        if config.merge? && File.exist?(config.parameters_file_path) && File.exist?(config.parameters_file_path)
          added_condition_keys = conditions.map { |c| c[:name] } - left.raw_conditions.map { |c| c[:name] }
          removed_condition_keys = left.raw_conditions.map { |c| c[:name] } - conditions.map { |c| c[:name] }

          added_conditions = added_condition_keys.each_with_object([]) do |k, acc|
            acc.push(conditions.find { |c| c[:name] == k })
          end

          unchanged_name_conditions = (conditions.map { |c| c[:name] } & left.raw_conditions.map { |c| c[:name] }).each_with_object([]) do |k, acc|
            new = conditions.find { |c| c[:name] == k }
            old = left.raw_conditions.find { |c| c[:name] == k }

            if old == new
              acc.push(old)
            else
              acc.push(new)
            end
          end

          removed_condition_keys.each do |k|
            left.raw_conditions.delete_if {|c| c[:name] == k }
          end

          added_parameter_keys = parameters.keys - left.raw_parameters.keys
          removed_parameter_keys = left.raw_parameters.keys - parameters.keys

          added_parameters = added_parameter_keys.each_with_object({}) do |k, acc|
            acc[k] = parameters[k]
          end

          unchanged_name_parameters = (parameters.keys & left.raw_parameters.keys).each_with_object({}) do |k, acc|
            new = parameters[k]
            old = left.raw_parameters[k]

            if old == new
              acc[k] = old
            else
              acc[k] = new
            end
          end

          removed_parameter_keys.each do |k|
            left.raw_parameters.delete(k)
          end

          conditions_yaml = JSON.parse(sort_conditions(unchanged_name_conditions + Remocon::ConditionFileDumper.new(added_conditions).dump).to_json).to_yaml
          parameters_yaml = JSON.parse(sort_parameters(unchanged_name_parameters.merge(Remocon::ParameterFileDumper.new(added_parameters).dump)).to_json).to_yaml
        else
          conditions_yaml = JSON.parse(Remocon::ConditionFileDumper.new(sort_conditions(conditions)).dump.to_json).to_yaml
          parameters_yaml = JSON.parse(Remocon::ParameterFileDumper.new(sort_parameters(parameters)).dump.to_json).to_yaml
        end

        File.open(config.conditions_file_path, "w+") do |f|
          f.write(conditions_yaml)
          f.flush
        end

        File.open(config.parameters_file_path, "w+") do |f|
          f.write(parameters_yaml)
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
