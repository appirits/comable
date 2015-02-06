version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_frontend'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide frontend functions for Comable.'
  s.description = 'Provide frontend functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'comable_core', version

  s.add_dependency 'rails', '>= 3.2.0', '< 4.2.0'
  s.add_dependency 'slim-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'compass-rails'
  s.add_dependency 'uglifier'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'kaminari'

  s.add_dependency 'jquery-rails', '~> 3.1.2', '<= 4.0.3'
  s.add_dependency 'jquery-ui-rails', '~> 5.0.3'
end
