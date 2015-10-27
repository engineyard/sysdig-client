# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sysdig/version'

Gem::Specification.new do |spec|
  spec.name          = "sysdig"
  spec.version       = Sysdig::VERSION
  spec.authors       = ["Josh Lane"]
  spec.email         = ["jlane@engineyard.com"]

  spec.summary       = %q{Ruby Client for Sysdig Cloud}
  spec.description   = %q{Ruby Sysdig Cloud API Client}
  spec.homepage      = "https://github.com/engineyard/sysdig-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "cistern",            "~> 2.2", "> 2.2.1"
  spec.add_dependency "ey-logger",          "~> 0.0"
  spec.add_dependency "faraday",            "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "faraday-cookie_jar", "~> 0.0"
end
