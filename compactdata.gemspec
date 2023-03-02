lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'COMPACTDATA/VERSION'

Gem::Specification.new do |spec|
  spec.name          = 'compactdata'
  spec.version       = COMPACTDATA::VERSION
  spec.authors       = ['Elliott Brown']
  spec.email         = ['mail@elliottinvent.com']

  spec.summary       = 'A Ruby parser for the CompactData serialisation format.'
  spec.homepage      = 'https://gitlab.com/NUMTechnology/CompactData/Libraries/compactdata-ruby'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end