# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-concernable/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-concernable"
  gem.version       = Activerecord::Concernable::VERSION
  gem.authors       = ["Blake Taylor"]
  gem.email         = ["blakefrost@gmail.com"]
  gem.description   = %q{A DSL for defining ActiveRecord concerns}
  gem.summary       = %q{
    Helps keep models skinny and code understandable by making it simple to
    define concerns and mix them into the affect class right from within the
    concerned class. See readme for more information.
  }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('activerecord')
  gem.add_development_dependency('rake')
end
