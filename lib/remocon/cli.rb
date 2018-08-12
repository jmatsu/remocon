# frozen_string_literal: true

module Remocon
  class CLI < ::Thor
    desc "token", "Get your access token"
    option :"service-json", type: :string, desc: "a file path to service account json"
    def token
      execute(Remocon::Command::GetToken)
    end

    desc "create", "Create a json to be pushed"
    option :parameters, type: :string, desc: "Specify the filepath if you want to use a custom parameters file"
    option :conditions, type: :string, desc: "Specify the filepath if you want to use a custom conditions file"
    option :prefix, type: :string, desc: "the directory name which will contain project-related files"
    option :id, type: :string, desc: "your project"
    option :dest, type: :string, hide: true, desc: "[Deprecated] the same with --prefix"
    def create
      execute(Remocon::Command::Create)
    end

    desc "push", "Upload remote configs based on a source json file"
    option :source, type: :string, desc: "the filepath of your config json file"
    option :etag, type: :string, desc: "the file path of etag"
    option :"raw-etag", type: :string, desc: "the raw value of etag"
    option :prefix, type: :string, desc: "the directory name which will contain project-related files"
    option :force, type: :boolean, default: false, desc: "force to ignore some warnings"
    option :token, type: :string, desc: "access token to your project"
    option :id, type: :string, desc: "your project id"
    option :raw_etag, type: :string, hide: true, desc: "[Deprecated] the raw value of etag"
    option :dest, type: :string, hide: true, desc: "[Deprecated] the same with --prefix"
    def push
      execute(Remocon::Command::Push)
    end

    desc "pull", "Pull remote configs"
    option :merge, type: :boolean, default: true, desc: "use the hash merge algorithm if true. default is true."
    option :prefix, type: :string, desc: "the directory name which will contain project-related files"
    option :token, type: :string, desc: "access token to your project"
    option :id, type: :string, desc: "your project id"
    option :dest, type: :string, hide: true, desc: "[Deprecated] the same with --prefix"
    def pull
      execute(Remocon::Command::Pull)
    end

    desc "validate", "Validate yml files"
    option :parameters, type: :string, desc: "Specify the filepath if you want to use a custom parameters file"
    option :conditions, type: :string, desc: "Specify the filepath if you want to use a custom conditions file"
    option :prefix, type: :string, desc: "the directory name which will contain project-related files"
    option :id, type: :string, desc: "your project id"
    option :token, type: :string, desc: "access token to your project"
    def validate
      execute(Remocon::Command::Validate)
    end

    private

    def execute(klass)
      exit(1) unless klass.new(options).run
    end
  end
end
