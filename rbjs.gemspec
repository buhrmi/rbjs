# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rbjs/version"

Gem::Specification.new do |s|
  s.name        = "rbjs"
  s.version     = Rbjs::VERSION
  s.authors     = ["Stefan Buhrmester"]
  s.email       = ["buhrmi@gmail.com"]
  s.homepage    = "http://github.com/buhrmi/rbjs"
  s.summary     = "Remote Javascript re-imagined"
  s.description = "Remote Javascript Builder for Ruby on Rails"

  s.rubyforge_project = "rbjs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "rails"
  s.add_runtime_dependency "activesupport"
end
