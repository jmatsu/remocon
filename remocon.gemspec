
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remocon/version'

Gem::Specification.new do |spec|
  spec.name          = 'remocon'
  spec.version       = Remocon::VERSION
  spec.authors       = ['Jumpei Matsuda']
  spec.email         = ['jmatsu.drm@gmail.com']

  spec.summary       = 'YAML-based firebase remote config manager'
  spec.description   = "This gem manages RemoteConfig's key-values based on YAML configuration."
  spec.homepage      = 'https://github.com/jmatsu/remocon'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'cmd'
  spec.executables   = spec.files.grep(%r{^cmd/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
