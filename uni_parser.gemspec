# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uni_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "uni_parser"
  spec.version       = UniParser::VERSION
  spec.authors       = ["Artem Petrov"]
  spec.email         = ["partos0511@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.6.1"
  spec.add_runtime_dependency "mechanize", "2.7.1"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "multi_json", "~> 1.9"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'minitest', "~> 5.3.0"
  spec.add_development_dependency 'minitest-vcr'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock', '< 1.16'
  spec.add_development_dependency 'wrong'
end
