# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lazy_files/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Mullins"]
  gem.email         = ["mcmullins@mail.umhb.edu"]
  gem.summary       = %q{A library for easily managing files and directories}
  gem.homepage      = "www.github.com/mcmullins/lazy_files"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lazy_files"
  gem.require_paths = ["lib"]
  gem.version       = Lazy::VERSION

  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'spwn'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rb-inotify'
end
