# frozen_string_literal: true

module Remocon
  class CLI < ::Thor
    desc 'create', 'Create a json to be pushed'
    option :parameters, type: :string, required: true, desc: 'a filepath of parameters file'
    option :conditions, type: :string, required: true, desc: 'a filepath of conditions file'
    option :dest, type: :string, desc: 'a filepath or directory path of destination'
    def create
      execute(Remocon::Command::Create)
    end

    desc 'push', 'Upload remote configs based on a source json file'
    class_option :source, type: :string, desc: 'a filepath of a source json file'
    option :etag, type: :string, desc: 'a filepath or raw value of etag'
    option :dest, type: :string, desc: 'a filepath or directory path of destination'
    option :force, type: :boolean, default: false, desc: 'force to ignore some warnings'
    def push
      execute(Remocon::Command::Push)
    end

    desc 'pull', 'Pull remote configs'
    option :dest, type: :string, desc: 'a filepath or directory path of destination'
    def pull
      execute(Remocon::Command::Pull)
    end

    desc 'validate', 'Validate yml files'
    option :parameters, type: :string, required: true, desc: 'a filepath of parameters file'
    option :conditions, type: :string, required: true, desc: 'a filepath of conditions file'
    def validate
      execute(Remocon::Command::Validate)
    end

    private

    def execute(klass)
      klass.new(options).run
    end
  end
end
