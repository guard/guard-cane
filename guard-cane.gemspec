# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'guard-cane'
  gem.version       = '0.2.1'
  gem.authors       = ["Justin Campbell"]
  gem.email         = ["justin@justincampbell.me"]
  gem.summary       = "Guard plugin for Cane"
  gem.description   = "Guard::Cane automatically runs Cane when files change"
  gem.homepage      = "https://github.com/guard/guard-cane"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency 'cane'
  gem.add_dependency 'guard', '>= 2.10.0'
  gem.add_dependency 'guard-compat', '~> 1.1'

  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.1'
end
