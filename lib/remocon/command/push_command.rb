# frozen_string_literal: false

module Remocon
  module Command
    class Push
      attr_reader :uri

      def initialize(opts)
        @opts = opts

        @project_id = ENV.fetch('FIREBASE_PROJECT_ID')
        @token = ENV.fetch('REMOTE_CONFIG_ACCESS_TOKEN')
        @uri = URI.parse("https://firebaseremoteconfig.googleapis.com/v1/projects/#{@project_id}/remoteConfig")
        @source_filepath = @opts[:source]
        @etag = File.exist?(@opts[:etag]) ? File.open(@opts[:etag]).read : @opts[:etag] if @opts[:etag]
        @ignore_etag = @opts[:force]
        @dest_dir = File.join(@opts[:dest], @project_id) if @opts[:dest]

        @cmd_opts = { validate_only: false }
      end

      def run
        # to prevent a real request in spec
        do_request
      end

      def client
        return @client if @client

        client = Net::HTTP.new(uri.host, uri.port)
        client.use_ssl = true

        @client = client
      end

      def request
        return @request if @request

        raise 'etag should be specified. If you want to ignore this error, then add --force option' unless @etag || @ignore_etag

        headers = {
          'Authorization' => "Bearer #{@token}",
          'Content-Type' => 'application/json; UTF8'
        }
        headers['If-Match'] = @etag || '*'

        request = Net::HTTP::Put.new(uri.request_uri, headers)
        request.body = ""
        request.body << File.read(@source_filepath).delete("\r\n")

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
          STDERR.puts 'Updated successfully.'
        when Net::HTTPBadRequest
          # sent json contains errors
          parse_error_body(response, response_body) if response_body
          STDERR.puts '400 but no error body' unless response_body
        when Net::HTTPUnauthorized
          # token was expired
          STDERR.puts '401 Unauthorized. A token might be expired or invalid.'
        when Net::HTTPForbidden
          # remote config api might be disabled or not yet activated
          STDERR.puts '403 Forbidden. RemoteConfig API might not be activated or be disabled.'
        when Net::HTTPConflict
          # local content is out-to-date
          STDERR.puts '409 Conflict. Remote was updated. Please update your local files'
        end
      end

      def parse_success_body(response, _success_body)
        return unless etag = response.header["etag"]

        if @dest_dir
          File.open(File.join(@dest_dir, 'etag'), 'w+') do |f|
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
          next unless k['@type'] == 'type.googleapis.com/google.rpc.BadRequest'

          k[:fieldViolations].each do |e|
            if e[:field].start_with?('remote_config.conditions')
              STDERR.puts 'CONDITION DEFINITION ERROR'
            else
              STDERR.puts 'PARAMETER DEFINITION ERROR'
            end

            STDERR.puts e[:description]
          end
        end
      end
    end
  end
end
