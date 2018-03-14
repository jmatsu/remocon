# frozen_string_literal: true

module Remocon
  class PullCommand
    include Remocon::InterpreterHelper

    def initialize(opts)
      @opts = opts

      @project_id = ENV.fetch('FIREBASE_PROJECT_ID')
      @token = ENV.fetch('REMOTE_CONFIG_ACCESS_TOKEN')
      @url = "https://firebaseremoteconfig.googleapis.com/v1/projects/#{@project_id}/remoteConfig"
      @dest_dir = File.join(@opts[:dest], @project_id) if @opts[:dest]

      @cmd_opts = { validate_only: false }
    end

    def run
      if @dest_dir
        FileUtils.mkdir_p(@dest_dir)

        raw_hash = JSON.parse(raw_json).with_indifferent_access

        raise 'etag cannot be fetched. please try again' unless @etag

        conditions, parameters = [raw_hash[:conditions] || [], raw_hash[:parameters] || {}]

        File.open(File.join(@dest_dir, "conditions.yml"), 'w+') do |f|
          f.write(JSON.parse(Remocon::ConditionFileDumper.new(sort_conditions(conditions)).dump.to_json).to_yaml)
          f.flush
        end

        File.open(File.join(@dest_dir, "parameters.yml"), 'w+') do |f|
          f.write(JSON.parse(Remocon::ParameterFileDumper.new(sort_parameters(parameters)).dump.to_json).to_yaml)
          f.flush
        end

        File.open(File.join(@dest_dir, "config.json"), 'w+') do |f|
          f.write(JSON.pretty_generate({ conditions: sort_conditions(conditions), parameters: sort_parameters(parameters) }))
          f.flush
        end

        File.open(File.join(@dest_dir, 'etag'), 'w+') do |f|
          f.write(@etag)
          f.flush
        end
      else
        STDOUT.puts raw_json
      end
    end

    private

    def raw_json
      return @raw_json if @raw_json

      @raw_json, @etag = open(@url, 'Authorization' => "Bearer #{@token}") do |io|
        [io.read, io.meta['etag']]
      end

      @raw_json
    end
  end
end
