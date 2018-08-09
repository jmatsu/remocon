[![Gem Version](https://badge.fury.io/rb/remocon.svg)](https://badge.fury.io/rb/remocon) [![Build Status](https://travis-ci.org/jmatsu/remocon.svg?branch=master)](https://travis-ci.org/jmatsu/remocon)

# Remocon

*remocon* is a CLI for Firebase Remote Config via its REST API.  
Conditions and parameters are managed by YAML files.

*This is still in beta. A diff mode should be supported when managing configs heavily.*

## Usage

### Get your access token

Since v0.3.0, remocon is supporting to get an access token.  
*If this doesn't work, then please try `bin/get_access_token <service-acount.json>`.*

```bash
token=$(bundle exec remocon --service-json=<path/to/service-account-json>)
```

### Get the current configs into your local

```bash
bundle exec remocon pull --prefix=projects --id=my_project_dev --token=xyz
```

Then, you can see `paremeters.yml, conditions.yml, config.json, etag` files in `projects/my_project_dev` directory.  
If you don't specify `--prefix`, then the command create the files in the working directory

*Environment variables*

Some variables can be injected by environment variables.

```bash
export REMOCON_FIREBASE_PROJECT_ID=<--id>
export REMOCON_FIREBASE_ACCESS_TOKEN=<--token>
export REMOCON_PREFIX=<--prefix> # Optional

FIREBASE_PROJECT_ID and REMOTE_CONFIG_ACCESS_TOKEN are supported but they are deprecated now
```

### Edit configs on your local

Condition definitions and parameter definitions are separated. You should modify these files.

*parameters.yml*

```yaml
key1: # key name
  value: 100 # default value
  conditions: 
    condition1:
      value: 200 # a value to be used if condition1 is satisfied
    condition2:
      file: path_to_file # you can use file content. the file content is used for a value
```

*conditions.yml*

```yaml
- name: condition1 # condition name
  expression: device.os == 'android' # expression
  tagColor: "INDIGO" # color name
- name: condition2
  expression: device.os == 'ios'
  tagColor: CYAN
```

### Update configs on remote

```bash
# Create new configs as projects/my_project_dev/config.json
bundle exec remocon create --prefix=projects --id=my_project_dev

# Upload projects/my_project_dev/config.json by using projects/my_project_dev/etag
bundle exec remocon push --prefix=projects --id=my_project_dev --token=xyz

# You can use custom paths for config.json and etag
bundle exec remocon push --source=</path/to/config json> --etag=</path/to/etag>

# Use the fixed etag value
bundle exec remocon push --raw_etag=<raw etag value>
```

## Installation

```ruby
gem 'remocon'
```

## Format

### Parameters

You can use String, Boolean, Integer, Json validators like below.

```yaml
key:
  value: # optional (either of this or file is required). Raw value and hash are allowed.
  file: # optional (either of this or value is required). File content value.
  normalizer: # optional. Either of ["integer", "string", "boolean", "json", "void"] (default: void).
  conditions: # optional. If you want use conditional values, then you need to create this section.
    condition_name: # must be in condition definitions.
      value: ...
      file: ...
```

### Conditions

It seems only three fields are supported by Remote Config. They are name, expression and tagColor.

## Supported Ruby Version 

Not EOL versions. ref https://www.ruby-lang.org/en/downloads/branches/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmatsu/remocon .

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
