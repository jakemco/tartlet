# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tartlet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jake M"]
  gem.email         = ["jakemaskiewicz@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/jakemask/tartlet"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tartlet"
  gem.require_paths = ["lib"]
  gem.version       = Tartlet::VERSION
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('methadone', '~> 1.2.6')
end
