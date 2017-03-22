# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "converse/version"

Gem::Specification.new do |spec|
  spec.name          = "dialogue"
  spec.version       = Converse::VERSION
  spec.authors       = ["Jamie Wright"]
  spec.email         = ["jamie@tastsu.io"]

  spec.summary       = %q{A DSL for defining conversations for Slack.}
  spec.description   = %q{Define and start conversations in Ruby for Slack bots.}
  spec.homepage      = "https://github.com/tatsuio/dialogue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "slack-ruby-client"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
