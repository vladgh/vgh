# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vgh/version'

Gem::Specification.new do |gem|
  gem.name          = "vgh"
  gem.version       = VGH::VERSION
  gem.authors       = ["Vlad Ghinea"]
  gem.email         = ["vgit@vladgh.com"]
  gem.description   = %q{Vlad's custom scripts}
  gem.summary       = %q{A collection of custom scripts used on VladGh.com}
  gem.homepage      = "https://github.com/vgh/vscripts"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "aws-sdk", [">= 1.6.6"]
  gem.add_runtime_dependency "sinatra", [">= 1.3.3"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "bundle"
  gem.add_development_dependency "bundler"
end
