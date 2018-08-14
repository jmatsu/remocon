# frozen_string_literal: true

module Remocon
  module InterpreterHelper
    include Remocon::ConditionSorter
    include Remocon::ParameterSorter

    def cmd_opts
      raise NotImplementedError
    end

    def require_parameters_file_path
      raise NotImplementedError
    end

    def require_conditions_file_path
      raise NotImplementedError
    end

    def read_parameters
      @read_parameters ||= begin
        parameter_interpreter = Remocon::ParameterFileInterpreter.new(require_parameters_file_path)
        parameter_interpreter.read(condition_names, cmd_opts)
      end
    end

    def parameter_hash
      @parameter_hash ||= sort_parameters(read_parameters.first)
    end

    def read_conditions
      @read_conditions ||= begin
        condition_interpreter = Remocon::ConditionFileInterpreter.new(require_conditions_file_path)
        condition_interpreter.read(cmd_opts)
      end
    end

    def condition_array
      @condition_array ||= sort_conditions(read_conditions.first)
    end

    def condition_names
      @condition_names ||= condition_array.map { |e| e[:name] }
    end
  end
end
