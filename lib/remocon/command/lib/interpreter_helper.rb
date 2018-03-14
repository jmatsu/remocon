# frozen_string_literal: true

module Remocon
  module InterpreterHelper
    include Remocon::ConditionSorter
    include Remocon::ParameterSorter

    attr_reader :parameters_filepath, :conditions_filepath, :cmd_opts

    def read_parameters
      @read_parameters ||= begin
        parameter_interpreter = Remocon::ParameterFileInterpreter.new(parameters_filepath)
        parameter_interpreter.read(condition_names, cmd_opts)
      end
    end

    def parameter_hash
      @parameter_hash ||= sort_parameters(read_parameters.first)
    end

    def parameter_errors
      @parameter_errors ||= read_parameters.second
    end

    def read_conditions
      @read_conditions ||= begin
        condition_interpreter = Remocon::ConditionFileInterpreter.new(conditions_filepath)
        condition_interpreter.read(cmd_opts)
      end
    end

    def condition_array
      @condition_array ||= sort_conditions(read_conditions.first)
    end

    def condition_errors
      @condition_errors ||= read_conditions.second
    end

    def condition_names
      @condition_names ||= condition_array.map { |e| e[:name] }
    end
  end
end
