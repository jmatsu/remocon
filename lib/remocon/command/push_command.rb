# frozen_string_literal: false

module Remocon
  module Command
    class Push

      attr_reader :config, :cmd_opts

      attr_reader :uri

      def initialize(opts)
        @config = Remocon::Config.new(opts)
        @cmd_opts = { validate_only: false }
      end

      def run
        # to prevent a real request in spec
        do_request
      end

      def uri
        @uri ||= URI.parse(config.endpoint)
      end

      def client
        return @client if @client

        client = Net::HTTP.new(uri.host, uri.port)
        client.use_ssl = true

        @client = client
      end

      def request
        return @request if @request

        raise "etag should be specified. If you want to ignore this error, then add --force option" unless config.etag

        headers = {
          "Authorization" => "Bearer #{config.token}",
          "Content-Type" => "application/json; UTF8",
          "If-Match" => config.etag,
        }

        request = Net::HTTP::Put.new(uri.request_uri, headers)
        request.body = ""
        request.body << File.read(config.config_json_file_path).delete("\r\n")

        @request = request
      end

      private

      def do_request
        response = client.request(request)

        response_body = begin
          json_str = response&.read_body
          JSON.parse(json_str).with_indifferent_access if json_str
        end

        case response
        when Net::HTTPOK
          parse_success_body(response, response_body)
          # intentional behavior
          STDERR.puts "Updated successfully."
        when Net::HTTPBadRequest
          # sent json contains errors
          parse_error_body(response, response_body) if response_body
          STDERR.puts "400 but no error body" unless response_body
        when Net::HTTPUnauthorized
          # token was expired
          STDERR.puts "401 Unauthorized. A token might be expired or invalid."
        when Net::HTTPForbidden
          # remote config api might be disabled or not yet activated
          STDERR.puts "403 Forbidden. RemoteConfig API might not be activated or be disabled."
        when Net::HTTPConflict
          # local content is out-to-date
          STDERR.puts "409 Conflict. Remote was updated. Please update your local files"
          else
            # do nothing
        end

        response.is_a?(Net::HTTPOK)
      end

      def parse_success_body(response, _success_body)
        etag = response.header["etag"]

        return unless etag

        if config.project_dir_path
          File.open(config.etag_file_path, "w+") do |f|
            f.write(etag)
            f.flush
          end
        else
          STDOUT.puts etag
        end
      end

      def parse_error_body(_response, error_body)
        STDERR.puts "Error name : #{error_body[:error][:status]}"
        STDERR.puts "Please check your json file"

        error_body.dig(:error, :details)&.each do |k|
          # for now, see only errors below
          next unless k["@type"] == "type.googleapis.com/google.rpc.BadRequest"

          k[:fieldViolations].each do |e|
            if e[:field].start_with?("remote_config.conditions")
              STDERR.puts "CONDITION DEFINITION ERROR"
            else
              STDERR.puts "PARAMETER DEFINITION ERROR"
            end

            STDERR.puts e[:description]
          end
        end
      end
    end
  end
end
