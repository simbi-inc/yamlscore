# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_score/version'

Gem::Specification.new do |spec|
  spec.name = 'yamlscore'
  spec.version       = YamlScore::VERSION
  spec.authors       = ['Konstantin Gredeskoul', 'Artem Kozaev']
  spec.email         = %w[kig@simbi.com artem@simbi.com]

  spec.summary       = 'Calculate a score based on YAML rules and formulas'
  spec.description   = 'Calculate a score based on YAML rules and formulas'
  spec.homepage      = 'https://github.com/Simbi-Inc/yaml-score'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  spec.add_development_dependency 'hashie'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov', '~> 0.15'
end
