# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'profiling/version'

Gem::Specification.new do |spec|
  spec.name          = 'profiling'
  spec.version       = Profiler::VERSION
  spec.authors       = ['Luke Duncalfe']
  spec.email         = ['lduncalfe@eml.cc']

  spec.summary       = 'Non-discriminatory profiler for Ruby MRI code.'
  spec.description   = 'Non-discriminatory profiler for Ruby MRI code. This gem is a small wrapper around the ruby-prof gem to do simple but powerful profiling'
  spec.homepage      = 'https://github.com/lukes/profiling'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[LICENCE.txt README.md]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['yard.run'] = 'yri' # use "yard" to build full HTML docs.

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4'
  spec.add_development_dependency 'yard', '~> 0.9'

  spec.add_dependency 'ruby-prof', '~> 1.4'

  spec.required_ruby_version = '>= 2.5.0' # Due to limitation of ruby-prof ~> v1.4.3
end
