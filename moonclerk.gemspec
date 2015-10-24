# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moonclerk/version'

Gem::Specification.new do |spec|
  spec.name          = "moonclerk"
  spec.version       = Moonclerk::VERSION
  spec.authors       = ["Trevor Hinesley"]
  spec.email         = ["trevor@trevorhinesley.com"]

  spec.summary       = %q{Gem to wrap MoonClerk.com read-only REST API}
  spec.description   = %q{Gem to wrap MoonClerk.com read-only REST API}
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/TrevorHinesley/moonclerk"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "rails", ">= 4.1"
  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
