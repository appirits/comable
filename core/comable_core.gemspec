$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'comable/core/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_core'
  s.version     = Comable::Core::VERSION
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide core functions for Comable.'
  s.description = 'Provide core functions for Comable.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'slim-rails'
end
