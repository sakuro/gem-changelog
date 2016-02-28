# -*- encoding: UTF-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem-changelog/version'

Gem::Specification.new do |spec|
  spec.name          = "gem-changelog"
  spec.version       = Gem::Changelog::VERSION
  spec.authors       = ["OZAWA Sakuro"]
  spec.email         = ["sakuro@2238club.org"]
  spec.description   = %q{This gem plugin add changelog subcommand to te gem system.}
  spec.summary       = %q{Show the changelog of given gem}
  spec.homepage      = "https://github.com/sakuro/gem-changelog"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
