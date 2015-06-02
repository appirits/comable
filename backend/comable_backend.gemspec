version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_backend'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/appirits/comable#comable'
  s.summary     = 'Provide backend functions for Comable.'
  s.description = 'Provide backend functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'comable_core', version

  s.add_dependency 'rails', '>= 3.2.0', '< 5'
  s.add_dependency 'slim-rails', '~> 3.0.1'
  s.add_dependency 'sass-rails' # TODO: '~> 5.0.1'
  s.add_dependency 'coffee-rails', '>= 3.2.2', '< 4.2'
  s.add_dependency 'compass-rails', '~> 2.0.4'
  s.add_dependency 'uglifier', '~> 2.7.0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.3'
  s.add_dependency 'font-awesome-rails', '~> 4.3.0.0'
  s.add_dependency 'kaminari', '~> 0.16.2'
  s.add_dependency 'dynamic_form', '~> 1.1.4'

  s.add_dependency 'ransack', '~> 1.6.3'

  s.add_dependency 'jquery-rails', '~> 3.1.2', '< 4.1'
  s.add_dependency 'jquery-ui-rails', '~> 5.0.3'
  s.add_dependency 'raphael-rails', '~> 2.1.2'
  s.add_dependency 'morrisjs-rails', '~> 0.5.1'
  s.add_dependency 'pace-rails', '~> 0.1.3'
  s.add_dependency 'gritter', '~> 1.1.0'
  s.add_dependency 'turbolinks', '~> 2.5.3'
  s.add_dependency 'jquery-turbolinks', '~> 2.1.0'

  s.add_dependency 'momentjs-rails', '~> 2.10.2'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.7.14'
end
