# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe InterpreterHelper do
    let(:test_klass) do
      Struct.new(:helper_klass) do
        include InterpreterHelper

        def cmd_opts
          {}
        end

        def require_parameters_file_path
          ""
        end

        def require_conditions_file_path
          ""
        end
      end
    end
    let(:parameters) { valid_parameters }
    let(:conditions) { valid_conditions }
    let(:errors) { [ValidationError.new, ValidationError.new] }

    let(:helper) { test_klass.new }

    context "#read_parameters" do
      let(:interpreter) { double("mock") }

      before do
        allow(ParameterFileInterpreter).to receive(:new).and_return(interpreter)
        allow(interpreter).to receive(:read).and_return([parameters, errors])
        allow(helper).to receive(:condition_names).and_return(%w(condition1 zxczx))
      end

      it "should return a result of ParameterFileInterpreter" do
        expect(interpreter).to receive(:read)
        expect(helper.read_parameters).to eq([parameters, errors])
      end
    end

    context "#parameter_hash" do
      before do
        allow(helper).to receive(:read_parameters).and_return([parameters, nil])
      end

      it "should return parameters" do
        expect(helper).to receive(:read_parameters)
        expect(helper.parameter_hash).to eq(parameters)
      end
    end

    context "#read_conditions" do
      let(:interpreter) { double("mock") }

      before do
        allow(ConditionFileInterpreter).to receive(:new).and_return(interpreter)
        allow(interpreter).to receive(:read).and_return([conditions, errors])
      end

      it "should return a result of ConditionFileInterpreter" do
        expect(interpreter).to receive(:read)
        expect(helper.read_conditions).to eq([conditions, errors])
      end
    end

    context "#condition_array" do
      before do
        allow(helper).to receive(:read_conditions).and_return([conditions, nil])
      end

      it "should return a result of ConditionFileInterpreter" do
        expect(helper).to receive(:read_conditions)
        expect(helper.condition_array).to eq(conditions)
      end
    end

    context "#condition_names" do
      before do
        allow(helper).to receive(:read_conditions).and_return([conditions, nil])
      end

      it "should return a result of ConditionFileInterpreter" do
        expect(helper).to receive(:read_conditions)
        expect(helper.condition_names).to eq(%w(condition1 zxczx))
      end
    end
  end
end
