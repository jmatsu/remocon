# frozen_string_literal: true

module Remocon
  class CLI < ::Thor
    desc "create", "Create a json to be pushed"
    option :parameters, type: :string, desc: "a file path of parameters file"
    option :conditions, type: :string, desc: "a file path of conditions file"
    option :dest, type: :string, desc: "a directory path of destination"
    option :id, type: :string, desc: "your project"
    def create
      execute(Remocon::Command::Create)
    end

    desc "push", "Upload remote configs based on a source json file"
    option :source, type: :string, desc: "the filepath of your config json file"
    option :etag, type: :string, desc: "the file path of etag"
    option :raw_etag, type: :string, desc: "the raw value of etag"
    option :dest, type: :string, desc: "the destination path"
    option :force, type: :boolean, default: false, desc: "force to ignore some warnings"
    option :token, type: :string, desc: "access token to your project"
    option :id, type: :string, desc: "your project id"
    def push
      execute(Remocon::Command::Push)
    end

    desc "pull", "Pull remote configs"
    option :dest, type: :string, desc: "the destination path"
    option :token, type: :string, desc: "access token to your project"
    option :id, type: :string, desc: "your project id"
    def pull
      execute(Remocon::Command::Pull)
    end

    desc "validate", "Validate yml files"
    option :parameters, type: :string, desc: "a file path of parameters file"
    option :conditions, type: :string, desc: "a file path of conditions file"
    option :token, type: :string, desc: "access token to your project"
    option :id, type: :string, desc: "your project id"
    def validate
      execute(Remocon::Command::Validate)
    end

    private

    def execute(klass)
      exit(1) unless klass.new(options).run
    end
  end
end
