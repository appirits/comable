$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'comable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable'
  s.version     = Comable::VERSION
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'
  s.description = 'Comable provides a simple way to add e-commerce features to your Ruby on Rails application.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'slim-rails'

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
  s.add_development_dependency 'utusemi', '>= 0.0.6'
  s.add_development_dependency 'yard'
end
