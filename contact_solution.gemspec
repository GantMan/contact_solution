# -*- encoding: utf-8 -*-
VERSION = "0.01"

Gem::Specification.new do |spec|
  spec.name          = "contact_solution"
  spec.version       = VERSION
  spec.authors       = ["Gant"]
  spec.email         = ["GantMan@gmail.com"]
  spec.description   = %q{Contact Solution is your refreshing prescription for RubyMotion Android contacts data.}
  spec.summary       = %q{Contact Solution is your refreshing prescription for RubyMotion Android contacts data.}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'bluepotion'
end
