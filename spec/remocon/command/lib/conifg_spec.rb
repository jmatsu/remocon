# frozen_string_literal: true

require "spec_helper"

module Remocon
  describe Config do
    let(:config) { Config.new(opts) }

    context "#endpoint" do
      context "opt-driven" do
        let(:opts) { { id: "xxxxx" } }

        it "should return an opt value" do
          expect(config.endpoint).to eq("https://firebaseremoteconfig.googleapis.com/v1/projects/xxxxx/remoteConfig")
        end

        it "should return an opt value even if env exists" do
          ENV[Remocon::Config::REMOCON_PROJECT_ID_KEY] = "yyyy"

          expect(config.endpoint).to eq("https://firebaseremoteconfig.googleapis.com/v1/projects/xxxxx/remoteConfig")
        end
      end

      context "env-driven" do
        let(:opts) { {} }

        it "should return a complete endpoint" do
          ENV[Remocon::Config::REMOCON_PROJECT_ID_KEY] = "yyyy"

          expect(config.endpoint).to eq("https://firebaseremoteconfig.googleapis.com/v1/projects/yyyy/remoteConfig")
        end

        it "backward compatibility" do
          ENV["FIREBASE_PROJECT_ID"] = "zzzzz"

          expect(config.endpoint).to eq("https://firebaseremoteconfig.googleapis.com/v1/projects/zzzzz/remoteConfig")
        end
      end

      context "no opts" do
        let(:opts) { {} }

        it "should fail unless exists" do
          expect { config.endpoint }.to raise_error(StandardError)
        end
      end
    end

    context "#token" do
      context "opt-driven" do
        let(:opts) { { token: "x" } }

        it "should return an opt value" do
          expect(config.token).to eq("x")
        end

        it "should return an opt value even if env exists" do
          ENV[Remocon::Config::REMOCON_ACCESS_TOKEN] = "yyyy"

          expect(config.token).to eq("x")
        end
      end

      context "env-driven" do
        let(:opts) { {} }

        it "should return a complete endpoint" do
          ENV[Remocon::Config::REMOCON_ACCESS_TOKEN] = "yyyy"

          expect(config.token).to eq("yyyy")
        end

        it "backward compatibility" do
          ENV["REMOTE_CONFIG_ACCESS_TOKEN"] = "xyz"

          expect(config.token).to eq("xyz")
        end
      end

      context "no opts" do
        let(:opts) { {} }

        it "should fail unless exists" do
          opts = {}

          expect { config.token }.to raise_error(StandardError)
        end
      end
    end

    context "#destination_dir_path" do
      context "opt-driven" do
        let(:opts) { { prefix: "x" } }

        it "should return an opt value" do
          expect(config.destination_dir_path).to eq("x")
        end

        it "should return an opt value even if env exists" do
          ENV[Remocon::Config::REMOCON_DESTINATION_DIR_KEY] = "yyyy"

          expect(config.destination_dir_path).to eq("x")
        end
      end
      context "backward compatibility" do
        let(:opts) { { dest: "x" } }

        it "should return an opt value" do
          expect(config.destination_dir_path).to eq("x")
        end

        it "should return an opt value even if env exists" do
          ENV[Remocon::Config::REMOCON_DESTINATION_DIR_KEY] = "yyyy"

          expect(config.destination_dir_path).to eq("x")
        end
      end

      context "env-driven" do
        let(:opts) { {} }

        it "should return a complete endpoint" do
          ENV[Remocon::Config::REMOCON_DESTINATION_DIR_KEY] = "yyyy"

          expect(config.destination_dir_path).to eq("yyyy")
        end
      end

      context "no opts" do
        let(:opts) { {} }

        it "should return nil" do
          expect(config.destination_dir_path).to be_falsey
        end
      end
    end

    context "#project_dir_path" do
      context "opt-driven" do
        let(:opts) { { dest: "x", id: "pro" } }

        it "should return an opt value" do
          expected = "#{config.destination_dir_path}/#{config.project_id}"

          expect(config.project_dir_path).to eq(expected)
        end
      end

      context "default value" do
        let(:opts) { { id: "id" } }

        it "should be same with id" do
          expect(config.project_dir_path).to eq("id")
        end
      end
    end

    context "#config_json_file_path" do
      context "opt-driven" do
        let(:opts) { { dest: "x", id: "pro", source: "xyz" } }

        it "should return an opt value" do
          expect(config.config_json_file_path).to eq("xyz")
        end
      end

      context "default value" do
        let(:opts) { { dest: "x", id: "pro" } }

        it "should return an opt value" do
          expected = "#{config.destination_dir_path}/#{config.project_id}/config.json"

          expect(config.config_json_file_path).to eq(expected)
        end
      end
    end

    context "#conditions_file_path" do
      context "opt-driven" do
        let(:opts) { { dest: "x", id: "pro", conditions: "xyz" } }

        it "should return an opt value" do
          expect(config.conditions_file_path).to eq("xyz")
        end
      end

      context "default value" do
        let(:opts) { { dest: "x", id: "pro" } }

        it "should return an opt value" do
          expected = "#{config.destination_dir_path}/#{config.project_id}/conditions.yml"

          expect(config.conditions_file_path).to eq(expected)
        end
      end
    end

    context "#parameters_file_path" do
      context "opt-driven" do
        let(:opts) { { dest: "x", id: "pro", parameters: "xyz" } }

        it "should return an opt value" do
          expect(config.parameters_file_path).to eq("xyz")
        end
      end

      context "default value" do
        let(:opts) { { dest: "x", id: "pro" } }

        it "should return an opt value" do
          expected = "#{config.destination_dir_path}/#{config.project_id}/parameters.yml"

          expect(config.parameters_file_path).to eq(expected)
        end
      end
    end

    context "#etag_file_path" do
      context "opt-driven but an etag file does not exist" do
        let(:opts) { { dest: "x", id: "pro", etag: "xyz" } }

        it "should return an opt value" do
          expect(config.etag_file_path).to eq("xyz")
        end
      end

      context "default value" do
        let(:opts) { { dest: "x", id: "pro" } }

        it "should return an opt value" do
          expected = "#{config.destination_dir_path}/#{config.project_id}/etag"

          expect(config.etag_file_path).to eq(expected)
        end
      end
    end

    context "#etag" do
      context "opt-driven" do
        let(:opts) { { raw_etag: "xyz" } }

        it "should return an opt value" do
          expect(config.etag).to eq("xyz")
        end

        it "should raise an error if both are specified" do
          opts.merge!(force: true)

          expect { config.etag }.to raise_error(StandardError)
        end
      end

      context "a etag file exists" do
        let(:opts) { { etag: fixture_path("etag_file") } }

        it "should return a content of a file" do
          expect(config.etag).to eq("XYZXYZXYZXYZ")
        end

        it "should return * if forced" do
          opts.merge!(force: true)

          expect(config.etag).to eq("*")
        end
      end

      context "a etag file does not exist" do
        let(:opts) { { etag: "not found" } }

        it "should return nil" do
          expect(config.etag).to be_falsey
        end

        it "should return * if forced" do
          opts.merge!(force: true)

          expect(config.etag).to eq("*")
        end
      end

      context "no opts" do
        let(:opts) { { id: "x" } }

        it "should return nil" do
          expect(config.etag).to be_falsey
        end
      end
    end
  end
end
