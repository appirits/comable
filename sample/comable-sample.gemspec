version = File.read(File.expand_path('../../COMABLE_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'comable-sample'
  s.version     = version
  s.authors     = ['YOSHIDA Hiroki']
  s.email       = ['hyoshida@appirits.com']
  s.homepage    = 'https://github.com/appirits/comable#comable'
  s.summary     = 'Provide sample data for Comable.'
  s.description = 'Provide sample data for Comable.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile']

  s.add_dependency 'comable-core', version

  s.add_dependency 'ffaker', '~> 2.0.0'
end
