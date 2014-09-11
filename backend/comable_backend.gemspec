$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "comable_backend/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "comable_backend"
  s.version     = ComableBackend::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ComableBackend."
  s.description = "TODO: Description of ComableBackend."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "pg"
end
