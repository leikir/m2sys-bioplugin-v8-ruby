$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "m2sys/bioplugin/v8/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "m2sys-bioplugin-v8"
  spec.version     = M2SYS::BioPlugin::V8::VERSION
  spec.authors     = ["Leikir Web"]
  spec.email       = ["web@leikir.io"]
  spec.homepage    = "https://web.leikir.io"
  spec.summary     = "API wrapper for M2SYS BioPlugin v8"
  spec.description = "API wrapper for M2SYS BioPlugin v8"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.1"
end
