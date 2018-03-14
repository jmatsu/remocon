# Remocon

*remocon* is a CLI for Firebase Remote Config via its REST API.  
Conditions and parameters are managed by YAML files.

## Usage

You need to get an access token for your firebase project.

### Get the current configs into your local

```
# Print the current config (raw json) to your console
bundle exec remocon pull

# Save the current config as YAML files
bundle exec remocon pull --dest=${path to dir}
```

### Edit configs on your local

Condition definitions and parameter definitions are separeted.

```
key1: # key name
  value: 100 # default value
  conditions: 
    condition1:
      value: 200 # a value to be used if condition1 is satisfied
    zxczx:
      file: path_to_file # the file content is used for a value
```

```
condition1:
  name: condition1 # condition name
  expression: device.os == 'android' # expression
  tagColor: "INDIGO" # color name
zxczx:
  name: zxczx
  expression: device.os == 'ios'
  tagColor: CYAN
```

### Update configs on remote

```
bundle exec remocon push --source=${path to a json file} --etag=${string or path to a file}
```

## Installation

```ruby
gem 'remocon'
```

## Format

### Parametes

#### Value types

You can use String, Boolean, Integer, Json like below.

```
key:
  value: "123"
  normalizer: "integer"

key:
  value: "xyz"
  normalizer: "string"

key:
  value: true
  normalizer: "boolean"

key:
  value: {"x": "y"}
  normalizer: "json"
```

### Conditions


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmatsu/remocon .

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
