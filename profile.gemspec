
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "profile/version"

Gem::Specification.new do |spec|
  spec.name          = "profile"
  spec.version       = Profile::VERSION
  spec.authors       = ["Luke Duncalfe"]
  spec.email         = ["lduncalfe@eml.cc"]

  spec.summary       = %q{Profiling without prejudice: A simple class for making ruby-prof gem more useable.}
  spec.description   = %q{Profiling without prejudice: A simple class for making ruby-prof gem more useable.}
  spec.homepage      = "https://github.com/lukes/profile"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.md)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "ruby-prof", "~> 0.15"
end
