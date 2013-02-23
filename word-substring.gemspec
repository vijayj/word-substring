# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Vijay J"]
  gem.email         = ["vijayj80@yahoo.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "word-substring"
  gem.require_paths = ["lib"]
  gem.version       = "1.0"
end
