# frozen_string_literal: true

module Remocon
  class CLI < ::Thor
    class_option :parameters, type: :string, desc: 'a filepath of parameters file'
    class_option :conditions, type: :string, desc: 'a filepath of conditions file'
    class_option :source, type: :string, desc: 'a filepath of a source json file'
    class_option :dest, type: :string, desc: 'a filepath or directory path of destination'
    class_option :etag, type: :string, desc: 'a filepath or raw value of etag'
    class_option :force, type: :boolean, desc: 'force to ignore some warnings'

    desc 'create', 'Create a json to be pushed'
    def create
      execute(Remocon::CreateCommand)
    end

    desc 'push', 'Upload remote configs based on a source json file'
    def push
      execute(Remocon::PushCommand)
    end

    desc 'pull', 'Pull remote configs'
    def pull
      execute(Remocon::PullCommand)
    end

    desc 'validate', 'Validate yml files'
    def validate
      execute(Remocon::ValidateCommand)
    end

    private

    def execute(klass)
      klass.new(options).run
    end
  end
end
