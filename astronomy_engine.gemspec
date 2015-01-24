# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'astronomy_engine/version'

Gem::Specification.new do |spec|
  spec.name          = 'astronomy_engine'
  spec.version       = AstronomyEngine::VERSION
  spec.authors       = ['Nick Aschenbach']
  spec.email         = ['nick.aschenbach@gmail.com']
  spec.summary       = %q{A light weight, mountable engine for the 'astronomy' gem}
  spec.description   = %q{A light weight, mountable engine for the 'astronomy' gem. Search or browse various astronomical phenomena}
  spec.homepage      = 'https://github.com/nick-aschenbach/astronomy-engine'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'capybara', '~> 2.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-nav'

  spec.add_runtime_dependency 'sinatra', '~> 1.4'
  spec.add_runtime_dependency 'sinatra-contrib', '~> 1.4'
  spec.add_runtime_dependency 'astronomy', '~> 0.2'
end