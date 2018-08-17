# frozen_string_literal: true

module Remocon
  module Command
    class Pull
      class RemoteConfig
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

        def conditions_to_be_compared
          JSON.parse(JSON.pretty_generate(condition_array.map { |c| c.skip_nil_values.stringify_values })).map(&:with_indifferent_access)
        end

        def parameters_to_be_compared
          JSON.parse(JSON.pretty_generate(parameter_hash.skip_nil_values.stringify_values)).with_indifferent_access
        end
      end

      include Remocon::ConditionSorter
      include Remocon::ParameterSorter

      attr_reader :config, :cmd_opts, :left

      def initialize(opts)
        @config = Remocon::Config.new(opts)
        @cmd_opts = { validate_only: false }
        @left = RemoteConfig.new(opts)
      end

      def run
        raw_json, etag = Remocon::Request.pull(config)

        raw_hash = JSON.parse(raw_json).with_indifferent_access

        raise "etag cannot be fetched. please try again" unless etag

        conditions = raw_hash[:conditions] || []
        parameters = raw_hash[:parameters] || {}

        if config.merge? && File.exist?(config.parameters_file_path) && File.exist?(config.parameters_file_path)
          unchanged_conditions, added_conditions, changed_conditions, = conditions_diff(left.conditions_to_be_compared, conditions)
          unchanged_parameters, added_parameters, changed_parameters, = parameters_diff(left.parameters_to_be_compared, parameters)

          conditions_yaml = JSON.parse(sort_conditions(unchanged_conditions + added_conditions + changed_conditions).to_json).to_yaml
          parameters_yaml = JSON.parse(sort_parameters(unchanged_parameters.merge(added_parameters).merge(changed_parameters)).to_json).to_yaml
        else
          conditions_yaml = JSON.parse(Remocon::ConditionFileDumper.new(sort_conditions(conditions)).dump.to_json).to_yaml
          parameters_yaml = JSON.parse(Remocon::ParameterFileDumper.new(sort_parameters(parameters)).dump.to_json).to_yaml
        end

        write_to_files(conditions_yaml, parameters_yaml, etag)
      end

      def conditions_diff(left, right)
        left_names = left.map { |c| c[:name] }
        right_names = right.map { |c| c[:name] }

        added_names = right_names - left_names
        removed_names = left_names - right_names

        added = added_names.each_with_object([]) do |k, acc|
          acc.push(right.find { |c| c[:name] == k })
        end

        changed = []
        unchanged = []

        (right_names & left_names).each do |k|
          old = left.find { |c| c[:name] == k }
          new = right.find { |c| c[:name] == k }

          if old == new
            unchanged.push(old)
          else
            changed.push(Remocon::ConditionFileDumper.new(new).dump)
          end
        end

        removed = []

        removed_names.each do |k|
          removed.push(left.find { |c| c[:name] == k })
        end

        [unchanged, added, changed, removed]
      end

      def parameters_diff(left, right)
        added_keys = right.keys - left.keys
        removed_keys = left.keys - right.keys

        added = added_keys.each_with_object({}) do |k, acc|
          acc.merge!(Remocon::ParameterFileDumper.new({ k => right[k] }).dump)
        end

        changed = {}
        unchanged = {}

        (right.keys & left.keys).each do |k|
          # both of left and right is config json's format
          # comparison should be done based on the format but dumped format should be returned
          old =  left[k]
          new = right[k]

          if old == new
            unchanged.merge!(Remocon::ParameterFileDumper.new({ k => old }).dump)
          else
            changed.merge!(Remocon::ParameterFileDumper.new({ k => new }).dump)
          end
        end

        removed = {}

        removed_keys.each do |k|
          removed[k] = Remocon::ParameterFileDumper.new({ k => left[k] }).dump
        end

        [unchanged, added, changed, removed]
      end

      private

      def write_to_files(conditions_yaml, parameters_yaml, etag)
        File.open(config.conditions_file_path, "w+") do |f|
          f.write(conditions_yaml)
          f.flush
        end

        File.open(config.parameters_file_path, "w+") do |f|
          f.write(parameters_yaml)
          f.flush
        end

        File.open(config.config_json_file_path, "w+") do |f|
          f.write(JSON.pretty_generate({ conditions: condition_array, parameters: parameter_hash }))
          f.flush
        end

        File.open(config.etag_file_path, "w+") do |f|
          f.write(etag)
          f.flush
        end
      end
    end
  end
end
