$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'comable/backend/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_backend'
  s.version     = Comable::Backend::VERSION
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide backend functions for Comable.'
  s.description = 'Provide backend functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'comable'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rspec-example_steps'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'bullet'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'utusemi'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'inch'
end
