# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-concernable/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-concernable"
  gem.version       = Activerecord::Concernable::VERSION
  gem.authors       = ["Blake Taylor"]
  gem.email         = ["blakefrost@gmail.com"]
  gem.description   = %q{A DSL for defining active record concerns}
  #gem.summary       = %q{ }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
