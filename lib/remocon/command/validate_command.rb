# frozen_string_literal: true

module Remocon
  module Command
    class Validate
      include Remocon::InterpreterHelper

      attr_reader :config, :cmd_opts

      def initialize(opts)
        @config = Remocon::Config.new(opts.merge(force: false))
        @cmd_opts = { validate_only: true }
      end

      def require_parameters_file_path
        config.parameters_file_path
      end

      def require_conditions_file_path
        config.conditions_file_path
      end

      def run
        validate_options

        artifact = {
            conditions: condition_array,
            parameters: parameter_hash
        }.skip_nil_values.stringify_values

        response, body = Tempfile.open do |t|
          t.write(JSON.pretty_generate(artifact))
          t.flush

          Request.validate(config, t)
        end

        if response.kind_of?(Net::HTTPOK)
          if response.header["etag"] =~ /^.*-0$/
            if etag_errors.empty?
              STDOUT.puts "valid"
              true
            else
              # validation api cannot validate etag
              STDERR.puts "the latest etag was updated"
            end
          else
            # https://firebase.google.com/docs/remote-config/use-config-rest#validate_before_publishing
            STDERR.puts "api server returned 200 but etag is not followed the valid format"
            false
          end
        else
          STDERR.puts body
          false
        end
      end

      private

      def validate_options
        raise ValidationError, "A condition file must exist" unless File.exist?(config.conditions_file_path)
        raise ValidationError, "A parameter file must exist" unless File.exist?(config.parameters_file_path)
        raise ValidationError, "An etag must be specified" unless config.etag
      end

      def remote_etag
        @remote_etag ||= Remocon::Request.fetch_etag(config)
      end

      def etag_errors
        if config.etag != "*" && config.etag != remote_etag
          [ValidationError.new("#{config.etag} is found but the latest etag is #{remote_etag || 'none'}")]
        else
          []
        end
      end
    end
  end
end
