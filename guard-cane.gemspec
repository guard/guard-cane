# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'guard-cane'
  gem.version       = '0.1.4'
  gem.authors       = ["Justin Campbell"]
  gem.email         = ["justin@justincampbell.me"]
  gem.summary       = "Guard plugin for Cane"
  gem.description   = "Guard::Cane automatically runs Cane when files change"
  gem.homepage      = "https://github.com/guard/guard-cane"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency 'cane'
  gem.add_dependency 'guard'

  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
