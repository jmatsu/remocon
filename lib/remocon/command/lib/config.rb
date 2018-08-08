# frozen_string_literal: true

module Remocon
  class Config
    REMOCON_PROJECT_ID_KEY = "REMOCON_FIREBASE_PROJECT_ID"
    REMOCON_ACCESS_TOKEN = "REMOCON_FIREBASE_ACCESS_TOKEN"

    REMOCON_PREFIX_KEY = "REMOCON_PREFIX"

    CONFIG_JSON_FILE = "config.json"
    CONDITIONS_FILE_NAME = "conditions.yml"
    PARAMETERS_FILE_NAME = "parameters.yml"
    ETAG_FILE_NAME = "etag"

    attr_reader :opts

    def initialize(opts)
      @opts = opts
    end

    def endpoint
      @endpoint ||= "https://firebaseremoteconfig.googleapis.com/v1/projects/#{project_id}/remoteConfig"
    end

    def project_id
      # FIREBASE_PROJECT_ID is for backward compatibility
      @project_id ||= (opts[:id] || ENV[REMOCON_PROJECT_ID_KEY] || ENV["FIREBASE_PROJECT_ID"] || raise("--id or #{REMOCON_PROJECT_ID_KEY} env var is required"))
    end

    def token
      # REMOTE_CONFIG_ACCESS_TOKEN is for backward compatibility
      @token ||= (opts[:token] || ENV[REMOCON_ACCESS_TOKEN] || ENV["REMOTE_CONFIG_ACCESS_TOKEN"] || raise("--token or #{REMOCON_ACCESS_TOKEN} env var is required"))
    end

    def destination_dir_path
      @destination_dir_path ||= (opts[:prefix] || opts[:dest] || ENV[REMOCON_PREFIX_KEY])
    end

    def project_dir_path
      @project_dir_path ||= begin
        dir_path = destination_dir_path
        (dir_path ? File.join(dir_path, project_id) : project_id).tap { |dir|
          FileUtils.mkdir_p(dir)
        }
      end
    end

    def config_json_file_path
      @config_json_file_path ||= opts[:source] || begin
        File.join(project_dir_path, CONFIG_JSON_FILE)
      end
    end

    def conditions_file_path
      @conditions_file_path ||= opts[:conditions] || begin
        File.join(project_dir_path, CONDITIONS_FILE_NAME)
      end
    end

    def parameters_file_path
      @parameters_file_path ||= opts[:parameters] || begin
        File.join(project_dir_path, PARAMETERS_FILE_NAME)
      end
    end

    def etag_file_path
      @etag_file_path ||= opts[:etag] || begin
        File.join(project_dir_path, ETAG_FILE_NAME)
      end
    end

    def etag
      @etag ||= begin
        if opts[:force] && opts[:raw_etag]
          raise "--force and --raw_etag cannot be specified"
        end

        opts[:force] && "*" || opts[:raw_etag] || File.exist?(etag_file_path) && File.open(etag_file_path).read
      end
    end
  end
end
