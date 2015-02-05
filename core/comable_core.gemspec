version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable_core'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/hyoshida/comable#comable'
  s.summary     = 'Provide core functions for Comable.'
  s.description = 'Provide core functions for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.required_ruby_version = '>= 2.1.5'

  s.add_dependency 'rails', '>= 3.2.0', '< 5'
  s.add_dependency 'devise', '~> 3.2'
  s.add_dependency 'enumerize', '~> 0.9.0'
  s.add_dependency 'state_machines-activerecord'
  s.add_dependency 'ancestry', '~> 2.1.0'
  s.add_dependency 'acts_as_list', '~> 0.6.0'
  s.add_dependency 'carrierwave', '~> 0.10.0'
  s.add_dependency 'cancancan', '~> 1.10'
end
