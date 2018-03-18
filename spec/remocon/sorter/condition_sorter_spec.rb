# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe ConditionSorter do
    let(:sorter) { Struct.new(:dummy) { include Remocon::ConditionSorter }.new }
    let(:target) do
      [
        {
          name: 'name1',
          expression: 'expression1',
          tagColor: 'tagColor1',
          custom1: 'custom1',
          custom2: 'custom2'
        },
        {
          name: 'name2',
          custom2: 'custom2',
          tagColor: 'tagColor2',
          custom1: 'custom1',
          expression: 'expression2'
        },
        {
          custom1: 'custom1',
          custom2: 'custom2',
          expression: 'expression3',
          name: 'name3',
          tagColor: 'tagColor3'
        },
        {
          expression: 'expression4',
          tagColor: 'tagColor4',
          name: 'name4',
          custom2: 'custom2',
          custom1: 'custom1'
        }
      ]
    end

    context '#sort_conditions' do
      it 'should have only string values' do
        expect(sorter.sort_conditions(target)).to eq([
          {
            name: 'name1',
            expression: 'expression1',
            tagColor: 'tagColor1',
            custom1: 'custom1',
            custom2: 'custom2'
          },
          {
            name: 'name2',
            expression: 'expression2',
            tagColor: 'tagColor2',
            custom1: 'custom1',
            custom2: 'custom2'
          },
          {
            name: 'name3',
            expression: 'expression3',
            tagColor: 'tagColor3',
            custom1: 'custom1',
            custom2: 'custom2'
          },
          {
            name: 'name4',
            expression: 'expression4',
            tagColor: 'tagColor4',
            custom1: 'custom1',
            custom2: 'custom2'
          }
        ].map(&:deep_stringify_keys))
      end
    end
  end
end
