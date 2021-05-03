# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calendar_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'calendar-exercise'
  spec.version       = CalendarClient::VERSION
  spec.authors       = 'Chantal Justamond'
  spec.email         = 'cjustamm66@me.com'
  spec.summary       = 'creates a meeting schedule for a set of meetings'
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib helpers]

  spec.required_ruby_version = '>= 2.7.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yaml'
end
