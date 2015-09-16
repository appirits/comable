version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable-core'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/appirits/comable#comable'
  s.summary     = 'Provide core functions for Comable.'
  s.description = 'Provide core functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.required_ruby_version = '>= 2.1.5'

  s.add_dependency 'rails', '>= 4.0.0', '< 5'
  s.add_dependency 'devise', '~> 3.5', '<= 3.5.1'
  s.add_dependency 'enumerize', '~> 0.9'
  s.add_dependency 'state_machine', '~> 1.2'
  s.add_dependency 'ancestry', '~> 2.1'
  s.add_dependency 'acts_as_list', '~> 0.6'
  s.add_dependency 'carrierwave', '~> 0.10'
  s.add_dependency 'cancancan', '~> 1.10'
  s.add_dependency 'highline', '~> 1.6', '>= 1.6.21'
  s.add_dependency 'comma', '~> 3.2', '>= 3.2.4'
  s.add_dependency 'axlsx_rails', '~> 0.3'
  s.add_dependency 'roo', '~> 1.13', '>= 1.13.2'
  s.add_dependency 'liquid', '~> 3.0', '>= 3.0.2'
  s.add_dependency 'liquid-rails', '~> 0.1', '>= 0.1.2'
  s.add_dependency 'friendly_id', '>= 4.0.10', '< 6'
end
