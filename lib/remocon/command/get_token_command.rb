# frozen_string_literal: true

module Remocon
  module Command
    class GetToken
      attr_reader :config, :cmd_opts

      def initialize(opts)
        @config = Remocon::Config.new(opts)
        @cmd_opts = {}
      end

      def run
        validate_options

        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(config.service_json_file_path),
          scope: "https://www.googleapis.com/auth/firebase.remoteconfig"
        )

        authorizer.fetch_access_token!
        STDOUT.puts authorizer.access_token

        authorizer.access_token
      end

      private

      def validate_options
        raise ValidationError, "a service account json file is not found" if config.service_json_file_path.nil? || !File.exist?(config.service_json_file_path)
      end
    end
  end
end
